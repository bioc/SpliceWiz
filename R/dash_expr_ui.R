ui_expr <- function(id) {
    ns <- NS(id)
    wellPanel(
        .ui_notice(),
        fluidRow(
            uiOutput(ns("ref_expr_infobox")),
            uiOutput(ns("bam_expr_infobox")),
                                              
            uiOutput(ns("se_expr_infobox")),
        ),
        fluidRow(
            column(4,
                wellPanel(
                    ui_ddb_project_dir(id, color = "default"), br(), # br(),
                    actionBttn(ns("run_pb_expr"), "Process Selected BAMs", 
                        style = "gradient", color = "success"),  br(), br(),
                    shinyFilesAttnButton(ns("file_expr_anno_load"), 
                        label = "Import Annotations from File", 
                        title = "Choose Sample Annotation Table", 
                        multiple = FALSE), br(), br(),
                    conditionalPanel(
                        ns = ns,
                        condition = paste(
                            "['Annotations'].indexOf(input.hot_switch_expr)",
                            ">= 0"
                        ),
                        ui_ddb_anno(id), br(),
                    ),
                    ui_ddb_exprSettings(id, color = "default"),  br(),
                    actionBttn(ns("run_collate_expr"), "Collate Experiment",
                        style = "gradient", color = "success"), br(), br(),
                    ui_ddb_anno_io(id, color = "default"), br(),
                    ui_ddb_sys(id, color = "default")
                )
            ),
            column(8,
                shinyWidgets::radioGroupButtons(
                    inputId = ns("hot_switch_expr"),
                    label = "Experiment Display",
                    choiceNames = c("Reference", "BAMs", "Files", "Annotations"),
                    choiceValues = c("ref", "BAMs", "Files", "Annotations"),
                    selected = "ref"
                ),
                conditionalPanel(
                    ns = ns,
                    condition = "['ref'].indexOf(input.hot_switch_expr) >= 0",
                    rHandsontableOutput(ns("hot_ref_expr"))
                ),
                conditionalPanel(
                    ns = ns,
                    condition = "['BAMs'].indexOf(input.hot_switch_expr) >= 0",
                    rHandsontableOutput(ns("hot_bams_expr"))
                ),
                conditionalPanel(
                    ns = ns,
                    condition = "['Files'].indexOf(input.hot_switch_expr) >= 0",
                    rHandsontableOutput(ns("hot_files_expr"))
                ),
                conditionalPanel(
                    ns = ns,
                    condition = paste(
                        "['Annotations'].indexOf(input.hot_switch_expr) >= 0"
                    ),
                    rHandsontableOutput(ns("hot_anno_expr"))
                )
            )
        ),
        # conditionalPanel(
            # ns = ns,
            # condition = paste(
                # "output.txt_reference_path_load != '' &&",
                # "input.expr_ddb_ref_load % 2 != 0"
            # ),
            # fluidRow(
                # infoBoxOutput(ns("fasta_source_infobox")),
                # infoBoxOutput(ns("gtf_source_infobox"))
            # ),
            # fluidRow(
                # infoBoxOutput(ns("mappa_source_infobox")),
                # infoBoxOutput(ns("NPA_source_infobox")),
                # infoBoxOutput(ns("BL_source_infobox"))
            # )
        # )
    )
}

ui_expr_limited <- function(id) {
    # Only loads experiment
    ns <- NS(id)
    wellPanel(
        fluidRow(
            uiOutput(ns("se_expr_infobox"))
        ),
        fluidRow(
            column(4,
                wellPanel(
                    # ui_ddb_find_expr_folder(id, color = "default"), br(),
                    shinyDirAttnButton(ns("dir_NxtSE_path_load"), 
                        label = "Select Experiment (NxtSE) folder", 
                        title = "Choose Experiment (NxtSE) Directory",
                        style = "gradient"
                    ), br(), br(),
                    shinyFilesAttnButton(ns("file_expr_anno_load"), 
                        label = "Import Annotations from File", 
                        title = "Choose Sample Annotation Table", 
                        multiple = FALSE), br(), br(),
                    # ui_ddb_load_expr(id, color = "default"), br(),
                    conditionalPanel(
                        ns = ns,
                        condition = paste(
                            "['Annotations'].indexOf(input.hot_switch_expr)",
                            ">= 0"
                        ),
                        ui_ddb_anno(id), br(),
                    ),
                    actionBttn(ns("build_expr"), "Load NxtSE from folder", 
                        style = "gradient", color = "success"),  br(), br(),
                    shinySaveAttnButton(ns("saveNxtSE_RDS"), 
                        "Save NxtSE as RDS",
                        title = "Save NxtSE as RDS",
                        filetype = list(RDS = "rds"),
                        style = "gradient"),  br(), br(),
                    shinyFilesAttnButton(ns("loadNxtSE_RDS"), 
                        "Load NxtSE from RDS",
                        title = "Select RDS file containing NxtSE", 
                        style = "gradient",
                        multiple = FALSE)
                )
            ),
            column(8,
                shinyWidgets::radioGroupButtons(
                    inputId = ns("hot_switch_expr"),
                    label = "Experiment Display",
                    choices = c("Files", "Annotations"),
                    selected = "Files"
                ),
                conditionalPanel(
                    ns = ns,
                    condition = "['Files'].indexOf(input.hot_switch_expr) >= 0",
                    rHandsontableOutput(ns("hot_files_expr"))
                ),
                conditionalPanel(
                    ns = ns,
                    condition = paste(
                        "['Annotations'].indexOf(input.hot_switch_expr) >= 0"
                    ),
                    rHandsontableOutput(ns("hot_anno_expr"))
                )
            )
        )
    )
}

ui_wellPanel_anno <- function(id) {
    ns <- NS(id)
    wellPanel(
        tags$h4("Annotation Columns"),
        uiOutput(ns("newcol_expr")), # done
        splitLayout(cellWidths = c("40%", "60%"), 
            wellPanel(
                radioButtons(ns("type_newcol_expr"), "Data Type",
                    c("character", "integer", "double"))
            ),
            wellPanel(
                actionButton(ns("addcolumn_expr"), "Add Column"), 
                br(),  # done
                actionButton(ns("removecolumn_expr"), 
                    "Remove Column") # done
            )
        )
    )
}

ui_ddb_sys <- function(id, color = "warning") {
    ns <- NS(id)
    ui_toggle_wellPanel_modular(
        inputId = "expr_ddb_sys",
        id = id,
        title = "System settings",
        color = color,
        icon = icon("computer", lib = "font-awesome"),

        shinyWidgets::sliderTextInput(
            inputId = ns("pbam_threads"), 
            label = "Threads for processing BAM",
            choices = c(1,2,4,6,8,12,16,24), 
            selected = 1
        ),
        shinyWidgets::sliderTextInput(
            inputId = ns("cd_threads"), 
            label = "Threads for collating experiment",
            choices = c(1,2,4,6,8), 
            selected = 1
        ),
        shinyWidgets::materialSwitch(
           inputId = ns("mem_mode"),
           label = "Low memory mode (for collating experiment)", right = TRUE,
           value = TRUE, status = "warning"
        ),
    )
}


ui_ddb_anno <- function(id, color = "warning") {
    ns <- NS(id)
    ui_toggle_wellPanel_modular(
        inputId = "expr_ddb_anno",
        id = id,
        title = "Add / Remove Annotation Columns",
        color = color,
        icon = icon("pen", lib = "font-awesome"),

        uiOutput(ns("newcol_expr")), # done
        splitLayout(cellWidths = c("40%", "60%"), 
            wellPanel(
                radioButtons(ns("type_newcol_expr"), "Data Type",
                    c("character", "integer", "double"))
            ),
            wellPanel(
                actionButton(ns("addcolumn_expr"), "Add Column"), 
                br(),  # done
                actionButton(ns("removecolumn_expr"), 
                    "Remove Column") # done
            )
        )
    )
}


ui_ddb_project_dir <- function(id, color = "danger") {
    ns <- NS(id)
    ui_toggle_wellPanel_modular(
        inputId = "expr_ddb_project_dir",
        id = id,
        title = "Define Project Folders",
        color = color,
        icon = icon("folder-open", lib = "font-awesome"),
  
        shinyDirButton(ns("dir_reference_path_load"), 
            label = "Choose Reference folder", 
            title = "Select reference path",
            buttonType = "primary"
        ),
        textOutput(ns("txt_reference_path_load")),br(),

        shinyDirButton(ns("dir_bam_path_load"), 
            label = "Choose BAM folder", 
            title = "Select path containing BAM files",
            buttonType = "primary"
        ),
        textOutput(ns("txt_bam_path_load")), br(),
    
        shinyDirButton(ns("dir_NxtSE_path_load"), 
            label = "Choose / Create Experiment (NxtSE) folder", 
            title = "Choose Experiment (NxtSE) Directory",
            buttonType = "primary"
        ),
        textOutput(ns("txt_NxtSE_path_load"))
    )
}

ui_ddb_anno_io <- function(id, color = "danger") {
    ns <- NS(id)
    ui_toggle_wellPanel_modular(
        inputId = "expr_ddb_anno_io",
        id = id,
        title = "Annotations Import/Export",
        color = color,
        icon = icon("folder-open", lib = "font-awesome"),

        actionButton(ns("anno_to_NxtSE"),
            "Export annotations to NxtSE folder",
            class = "btn-primary"
        ), br(), br(),
        
        actionButton(ns("anno_from_NxtSE"),
            "Import annotations from NxtSE folder",
            class = "btn-primary"
        ),  br(), br(),

        shinySaveButton(ns("anno_as_csv"), 
            label = "Export annotations as csv file", 
            title = "Export annotations as csv file", 
            buttonType = "primary", filetype = list(csv = "csv"),
            multiple = FALSE
        ), # br(), br(),

    )
}

ui_ddb_demo_load <- function(id, color = "danger") {
    ns <- NS(id)
    ui_toggle_wellPanel_modular(
        inputId = "expr_ddb_demo_load",
        id = id,
        title = "Load Demo Dataset",
        color = color,
        icon = icon("database", lib = "font-awesome"),

        actionButton(ns("makeDemoBAMS"), 
            "Place BAM files in temporary directory")
    )
}

ui_ddb_ref_load <- function(id, color = "danger") {
    ns <- NS(id)
    ui_toggle_wellPanel_modular(
        inputId = "expr_ddb_ref_load",
        id = id,
        title = "Reference",
        color = color,
        icon = icon("dna", lib = "font-awesome"),
        
        tags$h4("Select Reference Directory"),       
        shinyDirButton(ns("dir_reference_path_load"), 
            label = "Select reference path", 
            title = "Select reference path"),
        textOutput(ns("txt_reference_path_load")),br(),
        
        tags$h4("Clear Reference Path"),
        actionButton(ns("clearLoadRef"), "Deselect Reference")
    )
}

ui_ddb_sw_path <- function(id, color = "danger") {
    ns <- NS(id)
    ui_toggle_wellPanel_modular(
        inputId = "expr_ddb_pb_load",
        id = id,
        title = "Process BAM files",
        color = color,
        icon = icon("align-center", lib = "font-awesome"),
        
        tags$h4("Run processBAM on BAM files"),
        tags$div(
            title = paste("Select the cells",
                "containing the paths to the BAM files",
                "that you wish to process"),
            actionButton(ns("run_pb_expr"), 
                "Run processBAM()")
        ),
        textOutput(ns("txt_run_pb_expr"))
    )      
}

ui_ddb_build_annos <- function(id, color = "danger") {
    ns <- NS(id)
    ui_toggle_wellPanel_modular(
        inputId = "expr_ddb_expr_anno",
        id = id,
        title = "Add / Modify Annotations",
        color = color,
        icon = icon("edit", lib = "font-awesome"),

        tags$h4("Add Annotations"),
        shinyFilesButton(ns("file_expr_anno_load"), 
            label = "Import Data Frame from File", 
            title = "Choose Sample Annotation Table", 
            multiple = FALSE), br(), 
        actionButton(ns("add_anno"), "Edit Interactively"),
        # br(), br(),
        
        # tags$h4("Save / Load Annotations"),

        # shinySaveButton(ns("file_expr_anno_save_coldata"), 
            # "Save Annotations as RDS", "Save Annotations as RDS...", 
            # filetype = list(RDS = "rds")),
        # shinyFilesButton(ns("file_expr_anno_load_coldata"), 
            # label = "Load Annotations from RDS", 
            # title = "Load Annotations from RDS", 
            # multiple = FALSE)
    )
}

ui_ddb_exprSettings <- function(id, color = "danger") {
    ns <- NS(id)
    ui_toggle_wellPanel_modular(
        inputId = "expr_ddb_expr_load",
        id = id,
        title = "Experiment settings",
        color = color,
        icon = icon("flask", lib = "font-awesome"),

        shinyWidgets::materialSwitch(
            inputId = ns("novel_splicing_on"), 
            label = "Look for Novel Splicing", right = TRUE,
            value = FALSE, status = "success"
        ),
        br(),
        conditionalPanel(ns = ns,
            condition = "input.novel_splicing_on == true",
            shinyWidgets::materialSwitch(
                inputId = ns("novel_splicing_sameJunc"), 
                label = "Require novel reads to have one annotated splice site",
                right = TRUE,
                value = TRUE, 
                status = "success"
            ),
            numericInput(ns("nsOpt_minSamples"), 
                label = "Minimum samples with junctions", value = 3),  
            numericInput(ns("nsOpt_minSamplesThreshold"), 
                label = "Minimum samples with junctions above threshold", 
                value = 1),
            numericInput(ns("nsOpt_Threshold"), 
                label = "Threshold split read count", value = 10),
            shinyWidgets::materialSwitch(
                inputId = ns("nsOpt_TJ"), 
                label = "Utilize tandem junctions to find novel exons", 
                right = TRUE,
                value = TRUE, status = "success"
            ),
        ), br(),#br(),
        shinyWidgets::materialSwitch(
            inputId = ns("NxtSE_overwrite"), 
            label = "Overwrite existing NxtSE", right = TRUE,
            value = FALSE, status = "danger"
        ), br(),
        
        tags$h4("Clear Experiment"),
        actionButton(ns("clear_expr"), "Clear Experiment")
    )
}

ui_ddb_novel_splicing_settings <- function(id, color = "danger") {
    ns <- NS(id)
    ui_toggle_wellPanel_modular(
        inputId = "expr_ddb_expr_ns_settings",
        id = id,
        title = "Novel Splicing",
        color = color,
        icon = icon("flask", lib = "font-awesome"),

        shinyWidgets::switchInput(ns("novel_splicing_on"), 
            label = "Look for Novel Splicing", labelWidth = "200px"),
        br(),
        shinyWidgets::switchInput(ns("novel_splicing_sameJunc"), 
            label = "Only Include novel reads with one annotated splice site",
            labelWidth = "200px", value = TRUE),

        numericInput(ns("nsOpt_minSamples"), 
            label = "Minimum samples with junctions", value = 3),  
        numericInput(ns("nsOpt_minSamplesThreshold"), 
            label = "Minimum samples with junctions above threshold", 
            value = 1),
        numericInput(ns("nsOpt_Threshold"), 
            label = "Threshold split read count", value = 10),
    )
}


ui_ddb_find_expr_folder <- function(id, color = "danger") {
    ns <- NS(id)
    ui_toggle_wellPanel_modular(
        inputId = "expr_ddb_find_expr_folder",
        id = id,
        title = "Open Folder containing NxtSE",
        color = color,
        icon = icon("flask", lib = "font-awesome"),

        shinyDirButton(ns("dir_NxtSE_path_load"), 
            label = "Choose Folder (NxtSE)", 
            title = "Choose NxtSE path"
        )
    )
}

ui_ddb_save_NxtSE <- function(id, color = "danger") {
    ns <- NS(id)
    ui_toggle_wellPanel_modular(
        inputId = "expr_ddb_save_NxtSE",
        id = id,
        title = "Save / Load Pre-made NxtSE (Rds file)",
        color = color,
        icon = icon("file", lib = "font-awesome"),

        shinySaveButton(ns("saveNxtSE_RDS"), 
            "Save NxtSE as RDS", "Save NxtSE as RDS", 
            filetype = list(RDS = "rds")), br(), br(),
        shinyFilesButton(ns("loadNxtSE_RDS"), 
            label = "Load NxtSE from RDS", 
            title = "Select RDS file containing NxtSE", 
            multiple = FALSE)
    )
}



ui_ddb_load_expr <- function(id, color = "danger") {
    ns <- NS(id)
    ui_toggle_wellPanel_modular(
        inputId = "expr_ddb_expr_build",
        id = id,
        title = "Load NxtSE object from folder",
        color = color,
        icon = icon("flask", lib = "font-awesome"),

        actionButton(ns("build_expr"), "Load NxtSE object")
    )
}

ui_infobox_ref <- function(settings_file) {
    box1 <- infoBox(
        title = "Reference", 
        value = ifelse(file.exists(settings_file),
            "LOADED", "MISSING"),
        subtitle = ifelse(file.exists(settings_file),
            dirname(settings_file), ""),
        icon = icon("dna", lib = "font-awesome"),
        color = ifelse(file.exists(settings_file),
            "green", "red")
    )
    return(box1)
}

ui_infobox_bam <- function(bam_path, bam_files, escape = FALSE) {
    if(escape == TRUE) {
        box1 <- infoBox(
            title = "bam path", 
            value = "NOT REQUIRED",
            icon = icon("folder-open", lib = "font-awesome"),
            color = "green"
        )
    } else {
        ret <- is_valid(bam_files) && all(file.exists(bam_files))
        box1 <- infoBox(
            title = "bam path", 
            value = ifelse(!is_valid(bam_path),
                "MISSING", ifelse(ret == TRUE, "LOADED", "No BAMs found")),
            subtitle = ifelse(is_valid(bam_path),
                bam_path, ""),
            icon = icon("folder-open", lib = "font-awesome"),
            color = ifelse(!is_valid(bam_path),
                "red", ifelse(ret == TRUE, "green", "yellow"))
        )
    }
    return(box1)
}

ui_infobox_pb <- function(sw_path, sw_files, escape = FALSE) {
    if(escape == TRUE) {
        box1 <- infoBox(
            title = "SpliceWiz (processBAM) output", 
            value = "NOT REQUIRED",
            icon = icon("align-center", lib = "font-awesome"),
            color = "green"
        )
    } else {
        ret <- is_valid(sw_files) && all(file.exists(sw_files))
        box1 <-  infoBox(
            title = "SpliceWiz (processBAM) output", 
            value = ifelse(!is_valid(sw_path),
                "MISSING", ifelse(ret == TRUE, 
                "LOADED", "Some processBAM files missing")),
            subtitle = ifelse(is_valid(sw_path),
                sw_path, ""),
            icon = icon("align-center", lib = "font-awesome"),
            color = ifelse(!is_valid(sw_path),
            "red", ifelse(ret == TRUE, "green", "yellow"))
        )
    }
    return(box1)
}

ui_infobox_expr <- function(
        status = 0, msg = "", submsg = "", limited = FALSE
) {
    boxTitle <- "NxtSE path"
    if(limited) boxTitle <- "NxtSE object"
    
    box1 <-  infoBox(
        title = boxTitle, 
        value = ifelse(status == 0,
            "MISSING", msg),
        subtitle  = submsg,
        icon = icon("flask", lib = "font-awesome"),
        color = ifelse(status == 0, "red", 
            ifelse(status == 3, "blue", 
                ifelse(status == 2, "green", "yellow")
            )
        )
    )
    return(box1)
}