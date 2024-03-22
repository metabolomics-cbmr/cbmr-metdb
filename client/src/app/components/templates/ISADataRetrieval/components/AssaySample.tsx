import ModalWrapper from '../../../organisms/ModalWrapper';
import LazyCollapsible from '../../../atoms/LazyCollapsible';
import {useHistory} from 'react-router' ;
import {useCallback, useState, useEffect}  from 'react' ;
import { getAssaySampleList } from '../../../../shared/utils/api.utils';
import Sample from './Sample' ;
import Card from '../../../atoms/Card';

const AssaySamples = ({assayId, onClose}) => {

    const [assaySampleList, setAssaySamples] = useState<[]>([]);


    const getSamplesList = useCallback(async  () => {
        try {
            const sampleList =   await getAssaySampleList(assayId);

            setAssaySamples(sampleList["samples"]) ; 

        } catch (error) {
            alert('Could not get ISA Data Details');
            console.log({ isaDataError: error });
            //onClose();
          }
      }, [assayId]) ;

    
      useEffect(() => {
        if (!assayId) {
          alert('Invalid Investigation Id');
        } else {
            getSamplesList();
        }
      },[assayId,  getSamplesList])

    return (
    <ModalWrapper
      title="Results"
      closeButtonText="Close"
      onCancel={onClose}
    >
        {assaySampleList? 
          <>
            <Card className="p-0 w-100">

              {assaySampleList.map((sample, i ) =>  (
                <Sample  assayId = {assayId} sampleId={sample["sample_id"]} />
              )) 
              }
            </Card>
            </>

            : ""
            }    
    </ModalWrapper>
  );
};

export default AssaySamples;
