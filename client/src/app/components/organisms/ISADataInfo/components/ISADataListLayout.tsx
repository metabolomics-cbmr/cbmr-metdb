
import { ISADataDetails } from '../../../../shared/model/isadata-details.model';
// import Collapsible from '../../../atoms/Collapsible';
// import FileName from '../../../atoms/FileName';
// import TableLayout from '../../../layouts/TableLayout';
// import { ISA_INVESTIGATION_MAP } from '../ISADataInfo.const';
import { ROUTES } from '../../../../Routes';
import { useHistory } from 'react-router';
import { useState, useEffect } from "react" ;
import Card from '../../../atoms/Card';
import { getISADataListAPI } from '../../../../shared/utils/api.utils';

const ISADataListRow = ({ index, investigationId, title, description, onClick }) => {

  const history = useHistory();
  const navigateToRecords = () => {
    history.push(ROUTES.ISADATA_RETRIEVAL.replace(':id', investigationId));
  }

  return (
    <tr onClick={navigateToRecords}>
      <td className="p-3 text-center table-text">{index + 1}</td>
      <td className="p-3 table-text">{investigationId}</td>
      <td className="p-3 table-text">{title}</td>
      <td className="p-3 table-text">{description}</td>
    </tr>
  );
};



const ISADataListLayout = (props) => {

  const [isaDataList, setISADataList]  = useState<ISADataDetails[]>([])

  const getISADataList = async  () => {
    const isaDataListData =   await getISADataListAPI("1,10");


    console.log(isaDataListData["mst"]) ;
    return isaDataListData["mst"] 
    //setISADataList(prevISAData  =>  ([...prevISAData, ...isaDataListData["mst"]])) ; 
  };

  useEffect  (() => {
  getISADataList().then((function(result) {
      setISADataList(isaDataList.concat(result)) 
  })) 
}, [])
     

  return (
    <div className="d-flex flex-wrap">
      <div className="d-flex justify-content-between w-100 mb-3">
        <span className="table-header-text">ISA Data List</span>
        {/* <span className="view-all">View All</span> */}
      </div>
      <Card className="p-0 w-100">
        <table className="w-100">
          <thead>
            <tr className="border-bottom">
              <th className="p-3 text-center">Sr. No.</th>
              <th className="p-3">Investigation Id</th>
              <th className="p-3">Title</th>
              <th className="p-3">Description</th>
            </tr>
          </thead>
          <tbody>

          {isaDataList ?  isaDataList.map((item, i) => (
                  <ISADataListRow 
                    index={i}
                    investigationId={item["investigation_id"]}
                    title={item["title"]}
                    description={item["description"]} 
                    onClick={props.setId}
                  />
                ))
                : ""
              }

            {/* {isaDataList ?  isaDataList.map((item, i) => (
                  <ISADataListRow 
                    index={i}
                    investigationId={item.investigation_id}
                    title={item.title}
                    description={item.description}
                  />
                ))
                : ""
              } */}

          </tbody>
        </table>
      </Card>
    </div>
  );

}



// const ISADataDetailsRow = ({ description, value }) => (
//   <tr key={description} className="border-bottom">
//     <th scope="row" className="p-3">
//       {description}
//     </th>
//     <td className="p-3">{value}</td>
//   </tr>
// );

// const ISADataListLayout = () => {
//   return (
//     <ISADataList />

//     );
// };


// const ISADataDetailsLayout = ({
//   isaDataDetails,
// }: {
//   isaDataDetails: ISADataDetails | undefined;
// }) => {
//   return (
//     <Collapsible
//       trigger={<span className="table-header-text">Imported MS2 Data</span>}
//       hasBorder
//     >
//       <TableLayout
//         title=""
//         thead={[
//           <th className="p-3">Description</th>,
//           <th className="p-3">Value</th>,
//         ]}
//       >
//         {Object.entries(ISA_INVESTIGATION_MAP).map(([key, colName]) => (
//           <ISADataDetailsRow
//             description={colName}
//             value={
//               key === 'file_name' ? (
//                 <FileName>{isaDataDetails?.mst?.[key] || ''}</FileName>
//               ) : (
//                 isaDataDetails?.mst?.[key]
//               )
//             }
//           />
//         ))}
//       </TableLayout>
//     </Collapsible>
//   );
// };

export default ISADataListLayout;
