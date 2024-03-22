import { getISAInvResultsDetails } from '../../../../shared/utils/api.utils';
// import LazyCollapsible from '../../../atoms/LazyCollapsible';
// import Assay from './Assay' ;
import { ISAInvResultsDetails } from '../../../../shared/model/isadata-details.model';
import { useEffect, useState, useCallback  } from "react" ;
import Card from '../../../atoms/Card';
import '../ISADataRetrieval.style.scss';



const SampleRow = ({ assayId, sampleName, compoundName, intensity, datafile}) => {

      return (
        <>
          <tr >


            {/* <td className="p-3 table-text ">{assayId}</td> */}
            {/* <td className="p-3 table-text ">{sampleName}</td> */}

            <td className="p-3 table-text">{compoundName}</td>
            <td className="p-3 table-text">{intensity}</td>
            <td className="p-3 table-text">{datafile}</td>
          </tr>

      </>
    );

}


const InvSampleResults = ({sampleId}) => {
  const [isaSampleDetails, setISASampleData] = useState<ISAInvResultsDetails[]>([]);
  // const [isaStudyAssays, setISAAssays] = useState<[]>([]);



  const getISAInvResultsData = useCallback(async  () => {
      try {
          const isaInvResultsDetails =   await getISAInvResultsDetails(sampleId);
      
     
          setISASampleData(isaInvResultsDetails["mst"]) ; 


      } catch (error) {
          alert('Could not get ISA Data Details');
          console.log({ isaDataError: error });
          //onClose();
        }
    }, [sampleId]) ;

  
    useEffect(() => {
      if (!sampleId) {
        alert('Invalid Sample Id');
      } else {
        getISAInvResultsData();
      }
    },[sampleId,  getISAInvResultsData])


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

                {/* <th className="p-3 top-align id-width">Assay Id</th> */}
                {/* <th className="p-3 top-align title-width">Sample Name</th> */}
                <th className="p-3 top-align studydesc-width">Compound Name</th>
                <th className="p-3 top-align identifier-width">Intensity</th>
                <th className="p-3 top-align filename-width">Data File</th>
              </tr>
            </thead>
            <tbody>
            {isaSampleDetails ?  isaSampleDetails.map((item, i) => (
                
                <SampleRow 
                assayId = {item["assay_id"]} 
                sampleName = {item["sample_name"]}
                compoundName = {item["compound_name"]} 
                intensity = {item["intensity"]} 
                datafile = {item["datafile"]} 
              
              />

            )) : ""
            }

            </tbody>
          </table>
          </Card>

      </div>
    );

}

export default InvSampleResults;