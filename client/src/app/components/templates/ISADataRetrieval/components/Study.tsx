import { getISAStudyDetails } from '../../../../shared/utils/api.utils';
import LazyCollapsible from '../../../atoms/LazyCollapsible';
import Assay from './Assay' ;
import StudyPublications from './StudyPublications' ;
import StudyContacts from './StudyContacts' ;
import { ISAStudyDetails } from '../../../../shared/model/isadata-details.model';
import { useEffect, useState, useCallback  } from "react" ;
import Card from '../../../atoms/Card';
import '../ISADataRetrieval.style.scss';
import Protocol from './Protocol' ;



// const StudyRow = ({studyId, title, description, identifier, 
//   filename, submissionDate, publicReleaseDate} : {




const StudyRow = ({studyId, title, description, identifier, 
                filename, submissionDate, publicReleaseDate, assays, protocols}) => {

      return (
        <>
          <tr >


            <td className="p-3 table-text ">{studyId}</td>
            <td className="p-3 table-text">{title}</td>
            <td className="p-3 table-text">{description}</td>
            <td className="p-3 table-text">{identifier}</td>
            <td className="p-3 table-text">{filename}</td>
            <td className="p-3 table-text">{submissionDate}</td>
            <td className="p-3 table-text">{publicReleaseDate}</td>
          </tr>

          {protocols ? 
          <tr className="w-100">
            <td colSpan={5} className="w-100">
              <LazyCollapsible
                  trigger={<span className="table-header-text">Protocols Used</span>}
              >          

            <Protocol studyId={studyId} />

        </LazyCollapsible>
        </td>
        </tr>
        : ""}



          {assays ? 
          <tr className="w-100">
            <td colSpan={5} className="w-100">
              <LazyCollapsible
                  trigger={<span className="table-header-text">Assays</span>}
            
            >
            {/* {assays.map((item) => (
              <Assay assayId={item["assay_id"]} />
            ))} */}

          <Assay studyId={studyId} />

        </LazyCollapsible>
        </td>
        </tr>
        : ""}
      </>
    );

}


const Study = ({studyId}) => {
  const [isaStudyDetails, setISAStudyData] = useState<ISAStudyDetails[]>([]);
  const [isaStudyAssays, setISAAssays] = useState<[]>([]);
  const [studyProtocols, setStudyProtocols] = useState<[]>([]);
  const [studyPublications, setStudyPublications] = useState([]);
  const [studyContacts, setStudyContacts] = useState([]);


  const getISAStudyData = useCallback(async  () => {
      try {
          const isaStudyDataDetails =   await getISAStudyDetails(studyId);
      
      
          console.log(isaStudyDataDetails["mst"]) ;
          setISAStudyData(isaStudyDataDetails["mst"]) ; 
          setISAAssays(isaStudyDataDetails["dets"]) ; 
          setStudyProtocols(isaStudyDataDetails["protocols"]) ; 
          setStudyPublications(isaStudyDataDetails["publications"]) ; 
          setStudyContacts(isaStudyDataDetails["contacts"]) ; 


      } catch (error) {
          alert('Could not get ISA Data Details');
          console.log({ isaDataError: error });
          //onClose();
        }
    }, [studyId]) ;

  
    useEffect(() => {
      if (!studyId) {
        alert('Invalid Investigation Id');
      } else {
        console.log(" In GETTTTT")
        getISAStudyData();
      }
    },[studyId,  getISAStudyData])


//     <div className="d-flex justify-content-between w-100 mb-3">
//     <span className="table-header-text ">Study : {studyId}</span> 
//    {/* <span className="view-all">View All</span> */}
//  </div>


    return (
      <div className="d-flex flex-wrap borderless">

        <Card className="p-0 w-100">
          <table className="w-100">
            <thead>
              <tr className="border-bottom">

                <th className="p-3 top-align id-width">Id</th>
                <th className="p-3 top-align title-width">Title</th>
                <th className="p-3 top-align studydesc-width">Description</th>
                <th className="p-3 top-align identifier-width">Identifier</th>
                <th className="p-3 top-align filename-width">File Name</th>
                <th className="p-3 top-align">Submission Date</th>
                <th className="p-3 top-align">Public Release Date</th>                  
              </tr>
            </thead>
            <tbody>
            {isaStudyDetails ?  isaStudyDetails.map((item, i) => (
                
                <StudyRow 
                studyId = {item["study_id"]} 
                title = {item["title"]}
                description = {item["description"]} 
                identifier = {item["identifier"]} 
                filename = {item["filename"]} 
                submissionDate = {item["submission_date"]} 
                publicReleaseDate = {item["public_release_date"]}
                assays = {isaStudyAssays} 
                protocols = {studyProtocols}
              
              />

            )) : ""
            }

            </tbody>
          </table>
          {studyPublications.length?
            <LazyCollapsible
              trigger={<span className="table-header-text">Publications</span>}
              
            >
                <StudyPublications  studyId={studyId} />
            </LazyCollapsible>
            :"" 
            }

            {studyContacts.length?
            <LazyCollapsible
              trigger={<span className="table-header-text">Contacts</span>}
              
            >
                <StudyContacts  studyId={studyId} />
            </LazyCollapsible>
            :"" 
            }


          </Card>

      </div>
    );

}

export default  Study ;