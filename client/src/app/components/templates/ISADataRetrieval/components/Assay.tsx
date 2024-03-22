
// import { getISAAssayDetails } from '../../../../shared/utils/api.utils';
import { getISAStudyAssays } from '../../../../shared/utils/api.utils';
import { useHistory } from 'react-router';

import LazyCollapsible from '../../../atoms/LazyCollapsible';
import { ISAAssayDetails } from '../../../../shared/model/isadata-details.model';
import { useEffect, useState, useCallback  } from "react" ;
import Card from '../../../atoms/Card';
import '../ISADataRetrieval.style.scss';
import { ROUTES } from '../../../../Routes';
import AssaySample from './AssaySample'

const AssayRow = ({assayId, filename, measurementType, technologyType, 
                    technologyPlatform, resultsFile}) => {

    const history = useHistory();

    const [displayFlag, setDisplayFlag] = useState(false)
    // const navigateToRecords = () => {
    //   history.push(ROUTES.ASSAY_SAMPLES.replace(':id', assayId));
    // }


return (
    <>
    <tr  className="fullRow">

    <td className="p-3 table-text">{assayId}</td>
    <td className="p-3 table-text">{filename}</td>
    <td className="p-3 table-text">{measurementType}</td>
    <td className="p-3 table-text">{technologyType}</td>
    <td className="p-3 table-text">{technologyPlatform}</td>
    <td className="p-3 table-text underline cursor-pointer" onClick={() => setDisplayFlag(true)}><u>{resultsFile}</u></td>
    </tr>
    {displayFlag && (
        <AssaySample
          assayId = {assayId}
          onClose={() => {
            setDisplayFlag(false);
          }}
        />
      )}
    </>

    );

}


// const Assay = ({assayId}) => {
const Assay = ({studyId}) => {

    const [isaAssayDetails, setISAAssayData] = useState<ISAAssayDetails[]>([]);


  const getISAAssayData = useCallback(async  () => {
      try {
          const isaAssayDataDetails =   await getISAStudyAssays(studyId);
      
      
          console.log(isaAssayDataDetails["mst"]) ;
          setISAAssayData(isaAssayDataDetails["mst"]) ; 


      } catch (error) {
          alert('Could not get ISA Data Details');
          console.log({ isaDataError: error });
          //onClose();
        }
    }, [studyId]) ;

  
    useEffect(() => {
      if (!studyId) {
        alert('Invalid Study Id');
      } else {
        console.log(" In GETTTTT")
        getISAAssayData();
      }
    },[studyId,  getISAAssayData])



  //   <div className="d-flex justify-content-between w-100 mb-3">
  //   {/* <span className="table-header-text">Assay : {assayId}</span> */}
  //   {/* <span className="view-all">View All</span> */} 
  // </div>


    return (
      // <div className="d-flex flex-wrap">
      <div className="d-flex flex-wrap w-100" >
        
        
        <Card className="p-0 w-100 mb-5">
          <table className="w-100">
            <thead>
              <tr className="border-bottom">
                <th className="p-3">Assay Id</th>
                <th className="p-3">File Name</th>
                <th className="p-3">Measurement Type</th>
                <th className="p-3">Technology Type</th>                  
                <th className="p-3">Technology Platform</th>          
                <th className="p-3">Results File</th>          

              </tr>
            </thead>
            <tbody>
            {isaAssayDetails ?  isaAssayDetails.map((item, i) => (
                <AssayRow 
                assayId = {item["assay_id"]} 
                filename = {item["filename"]}
                measurementType = {item["measurement_type"]} 
                technologyType = {item["technology_type"]} 
                technologyPlatform = {item["technology_platform"]} 
                resultsFile   = {item["filename"]} 
              
              />

              
            )) : ""
            }

            </tbody>
          </table>
          </Card>
      </div>
    );
}

export default Assay ;