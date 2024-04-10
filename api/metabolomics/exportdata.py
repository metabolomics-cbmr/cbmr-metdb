import psycopg2
import psycopg2.extras
from metabolomics.components.db import close_db_conn, get_db_conn
from flask import render_template , current_app, jsonify , redirect, url_for, json , request, send_file   
from metabolomics.appbp import app_bp
from metabolomics.components.utilityfns import get_unhandled_exception_details
from metabolomics.display_detection_results import display_results
from io import BytesIO
import xlsxwriter 
import os


@app_bp.route("/resultsexcel/<id>, <client>, <show_only_above_threshold>")
def exportresultstoexcel(id, client, show_only_above_threshold="N"):

    results_data = display_results(id, 'external', show_only_above_threshold, True)

    buffer = BytesIO()
    results_span_rows = 30

    workbook = xlsxwriter.Workbook(buffer)
    cell_format = workbook.add_format({'bold': True})

    worksheet = workbook.add_worksheet()
    worksheet.set_column('B:B', 40)
    worksheet.set_column('C:C', 40)
    worksheet.set_column('E:E', 40)

    uploaddata = results_data["uploaddata"]

    #strip path  from uploaded file name 
    file_name = uploaddata["file_name"]
    no_path_file_name = file_name[file_name.rfind("/")+1:len(file_name)]

    worksheet.write("B1", "File uploaded for detection of Unknown Compound", cell_format)
    worksheet.write("C1", no_path_file_name, cell_format)

    worksheet.write("B2", "Comparison Id", cell_format)
    worksheet.write("C2", str(id), cell_format)

    worksheet.write("E1", "Number of spectra in uploaded file", cell_format )
    worksheet.write("F1", uploaddata["num_spectra_in_file"], cell_format)

    worksheet.write("E2", "Show only matches above threshold", cell_format )
    worksheet.write("F2", show_only_above_threshold, cell_format)

    settings = results_data["settings"]
    worksheet.write("B4", "Settings", cell_format)
    worksheet.write("B5",  "Number of matching peaks threshold")
    worksheet.write("C5", settings["matching_peaks"]["threshold"])


    worksheet.write("B6",  "Matching score threshold")
    worksheet.write("C6", settings["matching_score"]["threshold"])

    worksheet.write("B7",  "Precursor Mass Tolerance for selecting reference compounds")
    worksheet.write("C7", settings["pepmass_tolerance"]["threshold"])

    summary = results_data["summary"]

    worksheet.write("E4", "Summary", cell_format)
    worksheet.write("E5", "Number of matched above peaks and score threshold")
    worksheet.write("F5", summary['matches_over_threhold'])

    worksheet.write("E6", "Number of rows processed")
    worksheet.write("F6", summary['total_ms2_rows_compared'])

    worksheet.write("E7", "Number of unique known compounds matched")
    worksheet.write("F7", summary["unique_compounds_compared"] )

    

    pathprefix = "metabolomics"
    results_start_row = 11
    results_header_col = "B"
    results_value_col = "C"
    #row_increment = "1"

    mz_plot_col = "E"
    struct_plot_col = "N"

    srno = 0
    compare_data = results_data["output"]
    #current_app.logger.info('in export %s', data)
    for ele in compare_data:
        srno = srno + 1

        data = ele["data"]

        #current_app.logger.info('in export %s', data)
        row = results_start_row

        worksheet.write("A" + str(row).strip(), srno)

        worksheet.write(results_header_col + str(row).strip(), "Reference Compound", cell_format)

        worksheet.write(mz_plot_col + str(row).strip(), "MZ vs Intensity")
        worksheet.write(struct_plot_col + str(row).strip(), "Molecular Structure of Reference Compound")

        row = row + 1
        worksheet.write(results_header_col + str(row).strip(), "Name")
        worksheet.write(results_value_col + str(row).strip(), data["reference"]["name"])

        mz_plot = os.path.normpath(os.path.join(os.getcwd(),"metabolomics" + data["image"]["mz_intensity"]))
        mol_struct = os.path.normpath(os.path.join(os.getcwd(),"metabolomics" + data["image"]["molecular_structure"])) 

        # insert images in compound name row at respective columns
        worksheet.insert_image(mz_plot_col + str(row).strip(), mz_plot)
        worksheet.insert_image(struct_plot_col + str(row).strip(), mol_struct)


        row = row + 1
        worksheet.write(results_header_col +str(row).strip(), "Scan Number")
        worksheet.write(results_value_col + str(row).strip(), data["reference"]["scan_number"])

        row = row + 1
        worksheet.write(results_header_col + str(row).strip(), "Precursor Mass")
        worksheet.write(results_value_col + str(row).strip(), data["reference"]["precursor_mass"])

        row = row + 1
        worksheet.write(results_header_col + str(row).strip(), "Collision Energy")
        worksheet.write(results_value_col + str(row).strip(), data["reference"]["collision_energy"])

        row = row + 1
        worksheet.write(results_header_col + str(row).strip(), "Retention Time (secs)")
        worksheet.write(results_value_col + str(row).strip(), data["reference"]["retention_time"])

        row = row + 1
        worksheet.write(results_header_col + str(row).strip(), "Query Compound", cell_format)

        row = row + 1
        worksheet.write(results_header_col + str(row).strip(), "Name")
        worksheet.write(results_value_col + str(row).strip(), "Unknown")

        row = row + 1
        worksheet.write(results_header_col + str(row).strip(), "Scan Number")
        worksheet.write(results_value_col + str(row).strip(), data["query"]["scan_number"])

        row = row + 1
        worksheet.write(results_header_col + str(row).strip(), "Precursor Mass")
        worksheet.write(results_value_col + str(row).strip(), data["query"]["precursor_mass"])

        row = row + 1
        worksheet.write(results_header_col + str(row).strip(), "Collision Energy")
        worksheet.write(results_value_col + str(row).strip(), data["query"]["collision_energy"])

        row = row + 1
        worksheet.write(results_header_col + str(row).strip(), "Retention Time (secs)")
        worksheet.write(results_value_col + str(row).strip(), data["query"]["retention_time"])


        row = row + 1
        worksheet.write(results_header_col + str(row).strip(), "Matching Method")
        worksheet.write(results_value_col + str(row).strip(), data["result"]["match_method"])

        row = row + 1
        worksheet.write(results_header_col + str(row).strip(), "Number of Matching Peaks")
        worksheet.write(results_value_col + str(row).strip(), data["result"]["num_matching_peaks"])

        row = row + 1
        worksheet.write(results_header_col + str(row).strip(), "Result over the threshold")
        worksheet.write(results_value_col + str(row).strip(), data["result"]["over_threshold"])

        #calculate rowno for next compound comparison data
        results_start_row = results_start_row + results_span_rows

    if srno == 0:   # no data matching show_only_above_threshold
        worksheet.write(results_header_col + str(results_start_row).strip(), "No results to show", cell_format)

    workbook.close()
    buffer.seek(0)
    return send_file(buffer, mimetype="application/vnd.ms-excel", as_attachment=True, download_name="results_for_id" + str(id).strip() + ".xlsx")  #, attachment_filename="testing.xlsx", as_attachment=True)
    #return buffer

    # writer = pd.ExcelWriter(output, engine='xlsxwriter')

    # #taken from the original question
    # df_1.to_excel(writer, startrow = 0, merge_cells = False, sheet_name = "Sheet_1")
    # workbook = writer.book
    # worksheet = writer.sheets["Sheet_1"]
    # format = workbook.add_format()
    # format.set_bg_color('#eeeeee')
    # worksheet.set_column(0,9,28)

    # #the writer has done its job
    # writer.close()

    # #go back to the beginning of the stream
    # output.seek(0)

    # #finally return the file
    # return send_file(output, attachment_filename="testing.xlsx", as_attachment=True)


   

    #return jsonify(results_data), 200