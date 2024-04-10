import {getInvPublicationData } from '../../../../shared/utils/api.utils';
import LazyCollapsible from '../../../atoms/LazyCollapsible';
import { useEffect, useState, useCallback  } from "react" ;
import Card from '../../../atoms/Card';
import '../ISADataRetrieval.style.scss';
import { Publication } from '../../../../shared/model/isadata-details.model';


// const StudyRow = ({studyId, title, description, identifier, 
//   filename, submissionDate, publicReleaseDate} : {




const InvPublicationRow = ({authorList, doi, pubmedId,  title, status }) => {

      return (
        <>
          <tr >


            <td className="p-3 table-text ">{authorList}</td>
            <td className="p-3 table-text">{doi}</td>
            <td className="p-3 table-text">{pubmedId}</td>
            <td className="p-3 table-text">{title}</td>
            <td className="p-3 table-text">{status}</td>

          </tr>

      </>
    );

}


const InvPublications = ({investigationId}) => {
  const [invPublications, setInvPublications] = useState<Publication[]>([]);


  const getInvPublications = useCallback(async  () => {
      try {
          const invPublications =   await getInvPublicationData(investigationId);
      
     
          setInvPublications(invPublications["publications"]) ; 

      } catch (error) {
          alert('Could not get Investigation Publication Details');
          console.log({ isaDataError: error });
        }
    }, [investigationId]) ;

  
    useEffect(() => {
      if (!investigationId) {
        alert('Invalid Investigation Id');
      } else {
        getInvPublications();
      }
    },[investigationId,  getInvPublications])


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

                <th className="p-3 top-align ">Author List</th>
                <th className="p-3 top-align ">DOI</th>
                <th className="p-3 top-align ">PubMed Id</th>
                <th className="p-3 top-align ">Title</th>
                <th className="p-3 top-align ">Status</th>
              </tr>
            </thead>
            <tbody>
            {invPublications ?  invPublications.map((item, i) => (
                
                <InvPublicationRow 
                authorList = {item["author_list"]} 
                doi = {item["doi"]}
                pubmedId = {item["pubmed_id"]} 
                title = {item["title"]} 
                status= {item["status"]} 
              
              />

            )) : ""
            }

            </tbody>
          </table>
          </Card>

      </div>
    );

}

export default  InvPublications ;