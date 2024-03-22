import { getISAStudyDetails } from '../../../../shared/utils/api.utils';
import { ISAStudyDetails } from '../../../../shared/model/isadata-details.model';
import { useEffect, useState, useCallback  } from "react" ;
import Card from '../../../atoms/Card';
import '../ISADataRetrieval.style.scss';


// const StudyRow = ({studyId, title, description, identifier, 
//   filename, submissionDate, publicReleaseDate} : {




const ProtocolRow = ({name, description}) => {

      return (
          <tr >


            <td className="p-3 table-text ">{name}</td>
            <td className="p-3 table-text">{description}</td>
          </tr>

    );

}


const Protocol = ({studyId}) => {

    const [studyProtocols, setStudyProtocols] = useState<[]>([]);


  const getISAStudyData = useCallback(async  () => {
      try {
          const isaStudyDataDetails =   await getISAStudyDetails(studyId);
      
          setStudyProtocols(isaStudyDataDetails["protocols"]) ; 

      } catch (error) {
          alert('Could not get Protocol Details');
          console.log({ isaDataError: error });
          //onClose();
        }
    }, [studyId]) ;

  
    useEffect(() => {
      if (!studyId) {
        alert('Invalid Study Id');
      } else {
        console.log(" In GETTTTT")
        getISAStudyData();
      }
    },[studyId,  getISAStudyData])



    return (
      <div className="d-flex flex-wrap borderless">

        <Card className="p-0 w-100">
          <table className="w-100">
            <thead>
              <tr className="border-bottom">

                <th className="p-3 top-align id-width">Name</th>
                <th className="p-3 top-align studydesc-width">Description</th>
              </tr>
            </thead>
            <tbody>
            {studyProtocols ?  studyProtocols.map((item, i) => (
                
                <ProtocolRow 
                    name = {item["name"]} 
                    description = {item["description"]} 
              
              />

            )) : ""
            }

            </tbody>
          </table>
          </Card>

      </div>
    );

}

export default  Protocol ;