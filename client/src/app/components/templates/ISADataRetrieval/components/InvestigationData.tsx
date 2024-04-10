
import Card from '../../../atoms/Card';
import { getISADataDetails } from '../../../../shared/utils/api.utils';
import { useEffect, useState, useCallback } from 'react' ;
import { ISADataDetails } from '../../../../shared/model/isadata-details.model';
import LazyCollapsible from '../../../atoms/LazyCollapsible';
import Study from './Study' ;
import OntologyReference from './OntologyReference' ;
import InvPublications from './InvPublications' ;
import InvContacts from './InvContacts' ;


import '../ISADataRetrieval.style.scss';

const  InvestigationData = ({investigationId}) => {

    console.log(" Received  " + investigationId) ;

    const [isaDataDetails, setISADataDetails] = useState<ISADataDetails[]>([]);
    const [invStudies, setInvStudies] = useState([]);
    const [invPublications, setInvPublications] = useState([]);
    const [invContacts, setInvContacts] = useState([]);


    const getISADataList = useCallback(async  () => {
        try {
            const isaDataDetails =   await getISADataDetails(investigationId);
        
        
            console.log(isaDataDetails["mst"]) ;
            setISADataDetails(isaDataDetails["mst"]) ; 
            setInvStudies(isaDataDetails["dets"]) ; 
            setInvPublications(isaDataDetails["publications"]) ; 
            setInvContacts(isaDataDetails["contacts"]) ; 


        } catch (error) {
            alert('Could not get ISA Data Details');
            console.log({ isaDataError: error });
            //onClose();
          }
      }, [investigationId]) ;

    
      useEffect(() => {
        if (!investigationId) {
          alert('Invalid Investigation Id');
        } else {
          getISADataList();
        }
      },[investigationId,  getISADataList])

    



    // const investigationDetails = useISAInvestigationDetails(investigationId);


    const data  = isaDataDetails;

    return (
        <div className="d-flex flex-wrap">
          <div className="d-flex justify-content-between w-100 mb-3">
            <span className="table-header-text">Investigation Data</span>
            {/* <span className="view-all">View All</span> */}
          </div>
          <Card className="p-0 w-100">
            <table className="w-100">
              <thead>
                <tr className="border-bottom">

                  <th className="p-3 top-align id-width">Id</th>
                  <th className="p-3 top-align title-width">Title</th>
                  <th className="p-3 top-align desc-width">Description</th>
                  <th className="p-3 top-align">Identifier</th>
                  <th className="p-3 top-align">Submission Date</th>
                  <th className="p-3 top-align">Public Release Date</th>                  
                </tr>
              </thead>
              <tbody>
              <tr>
                <td className="p-3 table-text ">{data[0] ? data[0]["investigation_id"] : ""}</td>
                <td className="p-3 table-text ">{data[0] ? data[0]["title"] : ""}</td>
                <td className="p-3 table-text">{data[0] ? data[0]["description"] : ""}</td>
                <td className="p-3 table-text">{data[0] ? data[0]["identifier"] : ""}</td>
                <td className="p-3 table-text">{data[0] ? data[0]["submission_date"] : ""}</td>
                <td className="p-3 table-text">{data[0] ? data[0]["public_release_date"]: ""}</td>

                </tr>

              </tbody>
            </table>


            <LazyCollapsible
              trigger={<span className="table-header-text">Ontology</span>}
              
            >
                <OntologyReference  investigationId={investigationId} />
            </LazyCollapsible>


            {invPublications.length?
            <LazyCollapsible
              trigger={<span className="table-header-text">Publications</span>}
              
            >
                <InvPublications  investigationId={investigationId} />
            </LazyCollapsible>
            :"" 
            }

            {invContacts.length?
            <LazyCollapsible
              trigger={<span className="table-header-text">Contacts</span>}
              
            >
                <InvContacts  investigationId={investigationId} />
            </LazyCollapsible>
            :"" 
            }




            {invStudies? 
            <LazyCollapsible
              trigger={<span className="table-header-text">Studies</span>}
              
            >
              {invStudies.map((study, i ) =>  (
                <Study  studyId={study["study_id"]} />
              )) 
              }
            </LazyCollapsible>
            : ""
            }    

          {/* {invSamples? 
            <LazyCollapsible
              trigger={<span className="table-header-text">Results</span>}
              
            >
              {invSamples.map((sample, i ) =>  (
                <Sample  sampleId={sample["sample_id"]} />
              )) 
              }
            </LazyCollapsible>
            : ""
            }     */}

          </Card>
        </div>
      );


}

export default InvestigationData ;










