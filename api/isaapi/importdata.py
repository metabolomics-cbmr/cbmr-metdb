from isatools import isatab2json
import json 


isa_json = isatab2json.convert('./data/', validate_first=True, use_new_parser=True)
#isa_json = isatab2json.convert('./metabolights_data/', validate_first=True, use_new_parser=True)

jsonFile = open("isatab2json1234.json", "w")
jsonFile.write(json.dumps(isa_json))
jsonFile.close()


# isatab2jsono = isatab2json.ISATab2ISAjson_v1(3)

# #isa_json = isatab2jsono.convert('./data/', validate_first=True, use_new_parser=True)
# isa_json = isatab2jsono.convert('./data/')

# jsonFile = open("isatab2jsonv2.json", "w")
# jsonFile.write(json.dumps(isa_json))
# jsonFile.close()