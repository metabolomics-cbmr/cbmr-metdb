import { getInvOntologyData } from '../../../../shared/utils/api.utils';
import LazyCollapsible from '../../../atoms/LazyCollapsible';
import Assay from './Assay' ;
import { InvOntology } from '../../../../shared/model/isadata-details.model';
import { useEffect, useState, useCallback  } from "react" ;
import Card from '../../../atoms/Card';
import '../ISADataRetrieval.style.scss';


// const StudyRow = ({studyId, title, description, identifier, 
//   filename, submissionDate, publicReleaseDate} : {




const OntologyRow = ({name, file, version, description }) => {

      return (
        <>
          <tr >


            <td className="p-3 table-text ">{name}</td>
            <td className="p-3 table-text">{file}</td>
            <td className="p-3 table-text">{version}</td>
            <td className="p-3 table-text">{description}</td>
          </tr>

      </>
    );

}


const OntologyReference = ({investigationId}) => {
  const [invOntology, setInvOntology] = useState<InvOntology[]>([]);


  const getInvOntology = useCallback(async  () => {
      try {
          const invOntology =   await getInvOntologyData(investigationId);
      
     
          setInvOntology(invOntology["inv_onto"]) ; 

      } catch (error) {
          alert('Could not get Investigation Ontology Details');
          console.log({ isaDataError: error });
        }
    }, [investigationId]) ;

  
    useEffect(() => {
      if (!investigationId) {
        alert('Invalid Investigation Id');
      } else {
        getInvOntology();
      }
    },[investigationId,  getInvOntology])


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

                <th className="p-3 top-align id-width">Name</th>
                <th className="p-3 top-align filename-width">File</th>
                <th className="p-3 top-align  version-width">Version</th>
                <th className="p-3 top-align studydesc-width">Description</th>
              </tr>
            </thead>
            <tbody>
            {invOntology ?  invOntology.map((item, i) => (
                
                <OntologyRow 
                name = {item["name"]} 
                file = {item["file"]}
                version = {item["version"]} 
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

export default  OntologyReference ;