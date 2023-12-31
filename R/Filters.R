#' Filtering for IR and Alternative Splicing Events
#'
#' These function implements filtering of alternative splicing events,
#' based on customisable criteria. See [ASEFilter] for details on how to
#' construct SpliceWiz filters
#'
#' @details
#' We highly recommend using the default filters, which are as follows:
#' * (1) Depth filter of 20,
#' * (2) Participation filter requiring 70% coverage in IR events.
#' * (3) Participation filter requiring 40% coverage in MXE, SE, A5SS and A3SS 
#'        events
#'   (i.e. Included + Excluded isoforms must cover at least 40% of all junction
#'   events across the given region)
#' * (4) Consistency filter requring log difference of 2 (for skipped exon and
#'  mutually exclusive exon events, each junction must comprise at least 1/(2^2)
#'  = 1/4 of all reads associated with each isoform).
#'  For retained introns, the exon-intron overhangs must not differ by 1/4
#' * (5) Terminus filter: In alternate first exons, the splice junction must
#'   not be shared with another transcript for which it is not its first
#'   intron. For alternative last exons, the splice junction must not be
#'   shared with another transcript for which it is not its last intron
#' * (6) ExclusiveMXE filter: For MXE events, the two alternate
#'   casette exons must not overlap in their genomic regions
#' * (7) StrictAltSS filter: For A5SS / A3SS events, the two alternate splice
#'   sites must not be interrupted by an intron
#'
#' In all data-based filters, we require at least 80% samples (`pcTRUE = 80`)
#'   to pass this filters from the entire dataset (`minCond = -1`).
#'
#' Threshold depths for Participation filters:
#' 
#' For IR/RI, Participation filter is only applied for IR events
#' for which the intron depth is above a certain threshold (set by `minDepth`).
#' This avoids the filters running on samples for which there is no IR.
#' 
#' For non-IR ASEs, Participation is only run on events with
#' splice depth (SpliceOver metric) higher than `minDepth`. This avoids filters
#' running on events with low total participation (i.e., (Inc+Exc)/SpliceOver)
#'
#' Threshold depths for Consistency filters:
#' Consistency filters are only applied for events where the sum of 
#' upstream and downstream junction counts surpass a given threshold `minDepth`.
#' This is applied on both included and excluded counts (the latter only
#' applies to MXE). This avoids consistency filters running on events with
#' insufficient junction counts (leading to high variance between up/downstream
#' values).
#'
#' For an explanation of the various parameters mentioned here, see [ASEFilter]
#'
#' @param se the \linkS4class{NxtSE} object to filter
#' @param filterObj A single \linkS4class{ASEFilter} object.
#' @param filters A vector or list of one or more ASEFilter objects. If left
#'   blank, the SpliceWiz default filters will be used.
#' @return
#' For `runFilter` and `applyFilters`: a vector of type `logical`,
#'   representing the rows of NxtSE that should be kept.
#'
#' For `getDefaultFilters`: returns a list of default recommended filters
#'   that should be parsed into `applyFilters`.
#' @examples
#' # see ?makeSE on example code of how this object was generated
#'
#' se <- SpliceWiz_example_NxtSE()
#'
#' # Get the list of SpliceWiz recommended filters
#'
#' filters <- getDefaultFilters()
#'
#' # View a description of what these filters do:
#'
#' filters
#'
#' # Filter the NxtSE using the first default filter ("Depth")
#'
#' se.depthfilter <- se[runFilter(se, filters[[1]]), ]
#'
#' # Filter the NxtSE using all four default filters
#'
#' se.defaultFiltered <- se[applyFilters(se, getDefaultFilters()), ]
#' @name Run_SpliceWiz_Filters
#' @aliases getDefaultFilters applyFilters runFilter
#' @seealso [ASEFilter] for details describing how to create and assign settings
#'   to ASEFilter objects.
#' @md
NULL

#' @describeIn Run_SpliceWiz_Filters Returns a vector of recommended default
#'   SpliceWiz filters
#' @export
getDefaultFilters <- function() {
    f1 <- ASEFilter("Data", "Depth", pcTRUE = 80, minimum = 20)
    f2 <- ASEFilter("Data", "Participation", pcTRUE = 80,
        minimum = 70, minDepth = 5, EventTypes = c("IR", "RI"))
    f3 <- ASEFilter("Data", "Participation", pcTRUE = 80,
        minimum = 40, minDepth = 20,
        EventTypes = c("SE", "A5SS", "A3SS", "MXE"))
    f4 <- ASEFilter("Data", "Consistency", pcTRUE = 80,
        maximum = 2, minDepth = 20, EventTypes = c("MXE", "SE", "RI"))
    f5 <- ASEFilter("Annotation", "Terminus")
    f6 <- ASEFilter("Annotation", "ExclusiveMXE")
    f7 <- ASEFilter("Annotation", "StrictAltSS")
    return(list(f1, f2, f3, f4, f5, f6, f7))
}

#' @describeIn Run_SpliceWiz_Filters Run a vector or list of ASEFilter objects
#'   on a NxtSE object
#' @export
applyFilters <- function(se, filters = getDefaultFilters()) {
    if (!is.list(filters)) filters <- list(filters)
    if (length(filters) == 0) .log("No filters given")
    for (i in length(filters)) {
        if (!is(filters[[i]], "ASEFilter")) {
            stopmsg <- paste("Element", i,
                "of `filters` is not a ASEFilter object")
            .log(stopmsg)
        }
    }
    if (!is(se, "NxtSE")) {
        .log(paste("In applyFilters(),",
            "se must be a NxtSE object"))
    }
    filterSummary <- rep(TRUE, nrow(se))
    for (i in seq_len(length(filters))) {
        filterSummary <- filterSummary & runFilter(
            se, filters[[i]]
        )
    }
    return(filterSummary)
}

#' @describeIn Run_SpliceWiz_Filters Run a single filter on a NxtSE object
#' @export
runFilter <- function(se, filterObj) {
    if (!is(se, "NxtSE")) .log("`se` must be a NxtSE object")
    if (filterObj@filterClass == "Data") {
        if (filterObj@filterType == "Depth") {
            message("Running Depth filter")
            return(.runFilter_data_depth(se, filterObj))
        } else if (filterObj@filterType == "Participation") {
            message("Running Participation filter")
            return(.runFilter_data_coverage(se, filterObj))
        } else if (filterObj@filterType == "Consistency") {
            message("Running Consistency filter")
            return(.runFilter_data_consistency(se, filterObj))
        }
    } else if (filterObj@filterClass == "Annotation") {
        if (filterObj@filterType == "Modality") {
            message("Running Modality filter")
            return(.runFilter_anno_mode(se, filterObj))
        } else if (filterObj@filterType == "Protein_Coding") {
            message("Running Protein_Coding filter")
            return(.runFilter_anno_pc(se, filterObj))
        } else if (filterObj@filterType == "NMD") {
            message("Running NMD filter")
            return(.runFilter_anno_nmd(se, filterObj))
        } else if (filterObj@filterType == "TSL") {
            message("Running TSL filter")
            return(.runFilter_anno_tsl(se, filterObj))
        } else if (filterObj@filterType == "Terminus") {
            message("Running Terminus filter")
            return(.runFilter_anno_terminus(se, filterObj))
        } else if (filterObj@filterType == "ExclusiveMXE") {
            message("Running ExclusiveMXE filter")
            return(.runFilter_anno_mxe(se, filterObj))
        } else if (filterObj@filterType == "StrictAltSS") {
            message("Running StrictAltSS filter")
            return(.runFilter_anno_strictSS(se, filterObj))
        }
    } else {
        return(rep(TRUE, nrow(se)))
    }
}

################################################################################
# Individual functions:

.runFilter_cond_vec <- function(se, filterObj) {
    use_cond <- ifelse(
        (length(filterObj@condition) == 1 && filterObj@condition != "") &&
        filterObj@condition %in% colnames(colData(se)),
        TRUE, FALSE
    )
    if (use_cond) {
        cond_vec <- unlist(colData[,
            which(colnames(colData) == filterObj@condition)])
    } else {
        cond_vec <- NULL
    }
    return(cond_vec)
}

.runFilter_data_depth <- function(se, filterObj) {
    colData <- as.data.frame(colData(se))
    rowData <- as.data.frame(rowData(se))
    cond_vec <- .runFilter_cond_vec(se, filterObj)
    usePC <- filterObj@pcTRUE

    depth <- assay(se, "Depth")
    sum_res <- rep(0, nrow(se))
    if (!is.null(cond_vec)) {
        for (cond in unique(cond_vec)) {
            depth.subset <- depth[, which(cond_vec == cond), drop = FALSE]
            sum <- rowSums(depth.subset >= filterObj@minimum)
            sum_res <- sum_res +
                ifelse(sum * 100 / ncol(depth.subset) >= usePC, 1, 0)
        }
        n_TRUE <- filterObj@minCond
        if (n_TRUE == -1) n_TRUE <- length(unique(cond_vec))
        res <- (sum_res >= n_TRUE)
    } else {
        sum <- rowSums(depth >= filterObj@minimum)
        res <- ifelse(sum * 100 / ncol(depth) >= usePC, TRUE, FALSE)
    }
    res[!(rowData(se)$EventType %in% filterObj@EventTypes)] <- TRUE
    
    rm(depth)
    if(exists("depth.subset")) rm(depth.subset)
    gc()
    return(res)
}

.runFilter_data_coverage <- function(se, filterObj) {
    colData <- as.data.frame(colData(se))
    rowData <- as.data.frame(rowData(se))
    cond_vec <- .runFilter_cond_vec(se, filterObj)
    usePC <- filterObj@pcTRUE
    minDepth <- filterObj@minDepth

    cov <- assay(se, "Coverage")
    depth <- assay(se, "minDepth")
    cov[depth < minDepth] <- 1 # do not test if depth below threshold

    sum_res <- rep(0, nrow(se))
    if (!is.null(cond_vec)) {
        for (cond in unique(cond_vec)) {
            cov.subset <- cov[, which(cond_vec == cond), drop = FALSE]
            sum <- rowSums(cov.subset >= filterObj@minimum / 100)
            sum_res <- sum_res +
                ifelse(sum * 100 / ncol(cov.subset) >= usePC, 1, 0)
        }
        n_TRUE <- filterObj@minCond
        if (n_TRUE == -1) n_TRUE <- length(unique(cond_vec))
        res <- (sum_res >= n_TRUE)
    } else {
        sum <- rowSums(cov >= filterObj@minimum / 100)
        res <- ifelse(sum * 100 / ncol(cov) >= usePC, TRUE, FALSE)
    }
    res[!(rowData(se)$EventType %in% filterObj@EventTypes)] <- TRUE

    rm(depth, cov)
    if(exists("cov.subset")) rm(cov.subset)
    gc()
    return(res)
}

.runFilter_data_consistency <- function(se, filterObj) {
    colData <- as.data.frame(colData(se))
    rowData <- as.data.frame(rowData(se))
    cond_vec <- .runFilter_cond_vec(se, filterObj)
    usePC <- filterObj@pcTRUE
    minDepth <- filterObj@minDepth

    Up_Inc <- up_inc(se)
    Down_Inc <- down_inc(se)
    IntronDepth <- assay(se, "Included")[
        rowData$EventType %in% c("IR", "MXE", "SE", "RI"), ]
    minDepth.Inc <- Up_Inc + Down_Inc
    # do not test if depth below threshold
    # Up_Inc[minDepth.Inc < minDepth] <- IntronDepth[minDepth.Inc < minDepth]
    # Down_Inc[minDepth.Inc < minDepth] <- IntronDepth[minDepth.Inc < minDepth]
    IntronDepth[minDepth.Inc < minDepth] <- 0
    
    Excluded <- assay(se, "Excluded")[
        rowData$EventType %in% c("MXE"), ]
    Up_Exc <- up_exc(se)
    Down_Exc <- down_exc(se)
    minDepth.Exc <- Up_Exc + Down_Exc
    # do not test if depth below threshold
    # Up_Exc[minDepth.Exc < minDepth] <- Excluded[minDepth.Exc < minDepth]
    # Down_Exc[minDepth.Exc < minDepth] <- Excluded[minDepth.Exc < minDepth]
    Excluded[minDepth.Exc < minDepth] <- 0

    sum_res <- rep(0, nrow(se))
    if (!is.null(cond_vec)) {
        for (cond in unique(cond_vec)) {
            Up_Inc.subset <- Up_Inc[, which(cond_vec == cond), drop = FALSE]
            Down_Inc.subset <- Down_Inc[, which(cond_vec == cond), drop = FALSE]
            IntronDepth.subset <- IntronDepth[, which(cond_vec == cond),
                drop = FALSE]
            Up_Exc.subset <- Up_Exc[, which(cond_vec == cond), drop = FALSE]
            Down_Exc.subset <- Down_Exc[, which(cond_vec == cond), drop = FALSE]
            Excluded.subset <- Excluded[, which(cond_vec == cond), drop = FALSE]

            sum <- .runFilter_data_consistency_truths(
                Up_Inc.subset, Down_Inc.subset, 
                Up_Exc.subset, Down_Exc.subset, 
                IntronDepth.subset, Excluded.subset, 
                filterObj@maximum, rowData(se)$EventType
            )            
            sum_res <- sum_res +
                ifelse(sum * 100 / ncol(Up_Inc.subset) >= usePC, 1, 0)
        }
        n_TRUE <- filterObj@minCond
        if (n_TRUE == -1) n_TRUE <- length(unique(cond_vec))
        res <- (sum_res >= n_TRUE)
    } else {       
        sum <- .runFilter_data_consistency_truths(
            Up_Inc, Down_Inc, Up_Exc, Down_Exc,
            IntronDepth, Excluded, 
            filterObj@maximum, rowData(se)$EventType
        )
        res <- ifelse(sum * 100 / ncol(Up_Inc) >= usePC, TRUE, FALSE)
    }
    res[!(rowData(se)$EventType %in% filterObj@EventTypes)] <- TRUE

    rm(Up_Inc, Down_Inc, Up_Exc, Down_Exc, 
        minDepth.Inc, minDepth.Exc, IntronDepth, Excluded)
    if(exists("Up_Inc.subset")) {
        rm(Up_Inc.subset, Down_Inc.subset, IntronDepth.subset,
            Up_Exc.subset, Down_Exc.subset, Excluded.subset)
    }
    gc()
    return(res)
}

.runFilter_data_consistency_truths <- function(
    Up_Inc, Down_Inc, Up_Exc, Down_Exc,
    IntronDepth, Excluded, maximum, EventTypeVec
) {
    num_IR <- sum(EventTypeVec == "IR")
    num_MXE <- sum(EventTypeVec == "MXE")
    num_SE <- sum(EventTypeVec == "SE")
    num_other <- sum(!(EventTypeVec %in% c("IR", "MXE", "SE", "RI")))
    num_RI <- sum(EventTypeVec == "RI")
    num_samples <- ncol(Up_Inc)

    tmpIncTRUE <- DelayedArray(
        matrix(TRUE, nrow = num_other, ncol = num_samples))
    tmpExcTRUE1 <- DelayedArray(
        matrix(TRUE, nrow = num_IR, ncol = num_samples))
    tmpExcTRUE2 <- DelayedArray(
        matrix(TRUE, nrow = num_SE + num_other + num_RI, ncol = num_samples))
        
    truth_inc_temp <- 
        # abs(log2(Up_Inc + 1) - log2(IntronDepth + 1)) < maximum &
        # abs(log2(Down_Inc + 1) - log2(IntronDepth + 1)) < maximum
        -(log2(Up_Inc + 1) - log2(IntronDepth + 1)) < maximum &
        -(log2(Down_Inc + 1) - log2(IntronDepth + 1)) < maximum

    if(is(truth_inc_temp, "DelayedArray")) {
        truth_inc <- rbind(
            truth_inc_temp[seq_len(num_IR + num_MXE + num_SE),,drop = FALSE],
            tmpIncTRUE,
            truth_inc_temp[-seq_len(num_IR + num_MXE + num_SE),,drop = FALSE]
        )    
    } else {
        truth_inc <- rbind(
            truth_inc_temp[seq_len(num_IR + num_MXE + num_SE),,drop = FALSE],
            as.matrix(tmpIncTRUE),
            truth_inc_temp[-seq_len(num_IR + num_MXE + num_SE),,drop = FALSE]
        )    
    }

    if(is(Excluded, "DelayedArray")) {
        truth_exc <- rbind(
            tmpExcTRUE1,
            (
                # abs(log2(Up_Exc + 1) - log2(Excluded + 1)) < maximum &
                # abs(log2(Down_Exc + 1) - log2(Excluded + 1)) < maximum
                -(log2(Up_Exc + 1) - log2(Excluded + 1)) < maximum &
                -(log2(Down_Exc + 1) - log2(Excluded + 1)) < maximum
            ),
            tmpExcTRUE2
        )
    } else {
        truth_exc <- rbind(
            as.matrix(tmpExcTRUE1),
            (
                # abs(log2(Up_Exc + 1) - log2(Excluded + 1)) < maximum &
                # abs(log2(Down_Exc + 1) - log2(Excluded + 1)) < maximum
                -(log2(Up_Exc + 1) - log2(Excluded + 1)) < maximum &
                -(log2(Down_Exc + 1) - log2(Excluded + 1)) < maximum
            ),
            as.matrix(tmpExcTRUE2)
        ) 
    }

    truth_total <- truth_inc & truth_exc
    
    sum <- rowSums(truth_total)
    
    rm(truth_inc_temp, truth_inc, truth_exc, truth_total)
    gc()
    return(sum)
}

# returns if any of included or excluded is protein_coding
.runFilter_anno_mode <- function(se, filterObj) {
    rowSelected <- as.data.table(rowData(se))
    rowSelected <- rowSelected[!(get("EventType") %in% filterObj@EventTypes)]
    res <- rowData(se)$EventName %in% rowSelected$EventName
    return(res)
}

# returns if any of included or excluded is protein_coding
.runFilter_anno_pc <- function(se, filterObj) {
    rowSelected <- as.data.table(rowData(se))
    rowSelected <- rowSelected[
        get("Inc_Is_Protein_Coding") == TRUE |
        get("Exc_Is_Protein_Coding") == TRUE]
    rowSelected <- rowSelected[get("EventType") != "IR" |
        get("Inc_Is_Protein_Coding") == TRUE] # filter for CDS introns
    res <- rowData(se)$EventName %in% rowSelected$EventName
    res[!(rowData(se)$EventType %in% filterObj@EventTypes)] <- TRUE
    return(res)
}

.runFilter_anno_nmd <- function(se, filterObj) {
    rowSelected <- as.data.table(rowData(se))
    rowSelected <- rowSelected[!is.na(get("Inc_Is_NMD")) &
        !is.na(get("Exc_Is_NMD"))]
    rowSelected <- rowSelected[get("Inc_Is_NMD") != get("Exc_Is_NMD")]
    res <- rowData(se)$EventName %in% rowSelected$EventName
    res[!(rowData(se)$EventType %in% filterObj@EventTypes)] <- TRUE
    return(res)
}

.runFilter_anno_tsl <- function(se, filterObj) {
    rowSelected <- as.data.table(rowData(se))
    rowSelected <- rowSelected[get("Inc_TSL") != "NA" &
        get("Exc_TSL") != "NA"]
    rowSelected[, c("Inc_TSL") := as.numeric(get("Inc_TSL"))]
    rowSelected[, c("Exc_TSL") := as.numeric(get("Exc_TSL"))]
    rowSelected <- rowSelected[get("Inc_TSL") <= filterObj@minimum &
        get("Exc_TSL") <= filterObj@minimum]
    res <- rowData(se)$EventName %in% rowSelected$EventName
    res[!(rowData(se)$EventType %in% filterObj@EventTypes)] <- TRUE
    return(res)
}

.runFilter_anno_terminus <- function(se, filterObj) {
    rowSelected <- as.data.table(rowData(se))
    if(!all(c("is_always_first_intron","is_always_last_intron") %in% 
            colnames(rowSelected))) {
        .log(paste(
            "This experiment was collated with an old version of SpliceWiz.",
            "Rerun collateData with the current version before using the",
            "terminus filter"
        ), "message")
        return(rep(TRUE, nrow(se)))
    }
    AFE <- rowSelected[get("EventType") == "AFE"]
    ALE <- rowSelected[get("EventType") == "ALE"]
    rowSelected <- rowSelected[!(get("EventType") %in% c("ALE", "AFE"))]
    AFE <- AFE[get("is_always_first_intron") == TRUE]
    ALE <- ALE[get("is_always_last_intron") == TRUE]
    res <- rowData(se)$EventName %in% c(rowSelected$EventName, 
        ALE$EventName, AFE$EventName)
    res[!(rowData(se)$EventType %in% filterObj@EventTypes)] <- TRUE
    return(res)
}

.runFilter_anno_mxe <- function(se, filterObj) {
    rowSelected <- as.data.table(rowData(se))
    MXE <- rowSelected[get("EventType") == "MXE"]

    if(nrow(MXE) == 0) return(rep(TRUE, nrow(se)))

    rowSelected <- rowSelected[get("EventType") != "MXE"]
    cas_A <- .runFilter_anno_mxe_gr_casette(MXE$Event1a, MXE$Event2a)
    cas_B <- .runFilter_anno_mxe_gr_casette(MXE$Event1b, MXE$Event2b)
    OL <- findOverlaps(cas_A, cas_B)
    OL <- OL[from(OL) == to(OL)]
    MXE_exclude <- (seq_len(nrow(MXE)) %in% from(OL))
    MXE <- MXE[!MXE_exclude]

    res <- rowData(se)$EventName %in% c(rowSelected$EventName, MXE$EventName)        
    res[!(rowData(se)$EventType %in% filterObj@EventTypes)] <- TRUE
    return(res)
}

.runFilter_anno_strictSS <- function(se, filterObj) {
    rowSelected <- as.data.table(rowData(se))
    ASS <- rowSelected[get("EventType") %in% c("A5SS", "A3SS")]
    
    if(nrow(ASS) == 0) return(rep(TRUE, nrow(se)))
    
    rowSelected <- rowSelected[!(get("EventType")  %in% c("A5SS", "A3SS"))]

    gr1 <- .runFilter_anno_ssdiff(ASS$Event1a, ASS$Event1b)

    introns <- copy(ref(se)$elements)
    introns <- introns[get("type") == "intron"]
    gr2 <- .grDT(introns)
    
    OL <- findOverlaps(gr2, gr1, type = "within")

    ASS_exclude <- (seq_len(nrow(ASS)) %in% to(OL))
    ASS <- ASS[!ASS_exclude]

    res <- rowData(se)$EventName %in% c(rowSelected$EventName, ASS$EventName)        
    res[!(rowData(se)$EventType %in% filterObj@EventTypes)] <- TRUE
    return(res)
}

.runFilter_anno_mxe_gr_casette <- function(coord1, coord2) {
    if(length(coord1) != length(coord2))
        .log("INTERNAL ERROR: two MXE coord vectors must be of equal size")
    gr1 <- coord2GR(coord1)
    gr1$ID <- as.character(seq_len(length(gr1)))
    gr2 <- coord2GR(coord2)
    gr2$ID <- as.character(seq_len(length(gr2)))
    grbind <- c(gr1, gr2)
    return(unlist(
        .grlGaps(GenomicRanges::split(grbind, grbind$ID))
    ))
}

.runFilter_anno_ssdiff <- function(coord1, coord2) {
    if(length(coord1) != length(coord2))
        .log("ERROR: two A5SS/A3SS coord vectors must be of equal size")
    gr1 <- coord2GR(coord1)
    gr2 <- coord2GR(coord2)
    return(psetdiff(gr2,gr1))
}