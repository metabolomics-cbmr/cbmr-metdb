// import ModalWrapper from '../ModalWrapper';
// import ISADataDetailsLayout from './components/ISADataDetailsLayout';
// import useISADataInfo from './useISADataInfo.hook';
// import LazyCollapsible from '../../atoms/LazyCollapsible';

import {useState} from "react"

// import ISADataListLayout from './components/ISADataListLayout';
import AllInvestigations from "./components/AllInvestigations";

//import { ISADataDetailsInv } from "./ISADataDetails";

// import MS2FileCompoundLayout from './components/MS2FileCompoundLayout';

// const ISADataInfo = ({ investigationId, onClose }) => {
//   const isaDataDetails = useISADataInfo({ investigationId, onClose });
//   // const ms2FileCompounds = isaDataDetails?.dets[0] || [];
//   return (
//     <ModalWrapper
//       title="Imported MS2 File Details"
//       closeButtonText="Close"
//       onCancel={onClose}
//     >
//       <ISADataDetailsLayout isaDataDetails={isaDataDetails} />
//       <LazyCollapsible
//         trigger={<span className="table-header-text">Studies</span>}
//         hasBorder
//       >
//         {/* {ms2FileCompounds?.map((ms2FileCompoundShort) => (
//           <MS2FileCompoundLayout ms2FileCompoundShort={ms2FileCompoundShort} />
//         ))} */}
//       </LazyCollapsible>
//     </ModalWrapper>
//   );
// };
const ISADataList = () => {

    return(
        <div>
        {/* <ISADataListLayout  /> */}
        <AllInvestigations />
        </div>

    ) ;
}




 export {ISADataList} ;
