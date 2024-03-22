import { getISASampleDetails } from '../../../../shared/utils/api.utils';
import LazyCollapsible from '../../../atoms/LazyCollapsible';
import InvResults from './InvResults';
import { ISASampleDetails } from '../../../../shared/model/isadata-details.model';
import { useEffect, useState, useCallback } from 'react';
import Card from '../../../atoms/Card';
import '../ISADataRetrieval.style.scss';

// const StudyRow = ({studyId, title, description, identifier,
//   filename, submissionDate, publicReleaseDate} : {

const SampleRow = ({ sampleId, sampleName }) => {
  const [isOpen, setIsOpen] = useState(false);
  return (
    <>
      

      <tr >
        <td colSpan={5} className="w-100 zero-margin zero-padding">
          <LazyCollapsible isOpen={isOpen} trigger={<tr onClick={() => setIsOpen((val) => !val)}>
        <td className="p-3 table-text "><strong>Sample Id : </strong> {sampleId}</td>
        <td className="p-3 table-text"><strong>Sample Name : </strong>{sampleName}</td>
      </tr>}>
            <InvResults sampleId={sampleId} />
          </LazyCollapsible>
        </td>
      </tr>
    </>
  );
};

const Sample = ({ assayId, sampleId }) => {
  const [isaSampleDetails, setISASampleData] = useState<ISASampleDetails[]>([]);

  const getISASampleData = useCallback(async () => {
    try {
      const isaSampleDetails = await getISASampleDetails(assayId, sampleId);

      setISASampleData(isaSampleDetails['mst']);
    } catch (error) {
      alert('Could not get ISA Sample Details');
      console.log({ isaDataError: error });
      //onClose();
    }
  }, [assayId, sampleId]);

  useEffect(() => {
    if (!sampleId) {
      alert('Invalid Sample Id');
    } else {
      console.log(' In GETTTTT');
      getISASampleData();
    }
  }, [sampleId, getISASampleData]);

  //     <div className="d-flex justify-content-between w-100 mb-3">
  //     <span className="table-header-text ">Study : {studyId}</span>
  //    {/* <span className="view-all">View All</span> */}
  //  </div>

  return (
    <div className="d-flex flex-wrap borderless">
      {/* <Card className="p-0 w-100"> */}
        <table className="w-100">
          {/* <thead>
            <tr className="border-bottom">
              <th className="p-3 top-align id-width">Sample Id</th>
              <th className="p-3 top-align title-width">Sample Name</th>
            </tr>
          </thead> */}
          <tbody>
            {isaSampleDetails
              ? isaSampleDetails.map((item, i) => (
                  <SampleRow
                    sampleId={item['sample_id']}
                    sampleName={item['sample_name']}
                  />
                ))
              : ''}
          </tbody>
        </table>
      {/* </Card> */}
    </div>
  );
};

export default Sample;
