import ModalWrapper from '../ModalWrapper';
import ISADataDetailsLayout from './components/ISADataDetailsLayout';
import useISADataInfo from './useISADataInfo.hook';
import LazyCollapsible from '../../atoms/LazyCollapsible';
import { useState,useEffect } from "react" ;
import { ISADataDetails } from '../../../shared/model/isadata-details.model';
import { getISADataDetails } from '../../../shared/utils/api.utils';


// import MS2FileCompoundLayout from './components/MS2FileCompoundLayout';

const ISADataDetailsInv = ({ investigationId, onClose }) => {
  
  console.log( "Inv - " + investigationId)
  const [isaDataDetails, setISADataList]  = useState<ISADataDetails[]>([])

  const getISADataList= async  () => {
    const isaDataListData =   await getISADataDetails(investigationId);


    console.log(isaDataListData["mst"]) ;
    return isaDataListData["mst"] 
    //setISADataList(prevISAData  =>  ([...prevISAData, ...isaDataListData["mst"]])) ; 
  };

  useEffect  (() => {
    console.log(" Inuseeffect") ;
    getISADataList().then((function(result) {
      setISADataList(isaDataDetails.concat(result)) 
  })) 
}, [])

  console.log("WWW")
  console.log(isaDataDetails)  ;
  // const ms2FileCompounds = isaDataDetails?.dets[0] || [];
  return (
    <ModalWrapper
      title="Investigation Details"
      closeButtonText="Close"
      onCancel={onClose}
    >
      <ISADataDetailsLayout isaDataDetails={isaDataDetails} />
      <LazyCollapsible
        trigger={<span className="table-header-text">Studies</span>}
        hasBorder
      >
        {/* {ms2FileCompounds?.map((ms2FileCompoundShort) => (
          <MS2FileCompoundLayout ms2FileCompoundShort={ms2FileCompoundShort} />
        ))} */}
      </LazyCollapsible>
    </ModalWrapper>
  );


};

// const ISADataDetails = () => {
//     <ISADataDetailsLayout />

// } ;

 export {ISADataDetailsInv};
