import { MS2FileDetails } from '../../../../shared/model/ms2file-details.model';
import Collapsible from '../../../atoms/Collapsible';
import FileName from '../../../atoms/FileName';
import TableLayout from '../../../layouts/TableLayout';
import { FILE_DETAILS_MAP } from '../MS2FileInfo.const';

const Ms2FileDetailsRow = ({ description, value }) => (
  <tr key={description} className="border-bottom">
    <th scope="row" className="p-3">
      {description}
    </th>
    <td className="p-3">{value}</td>
  </tr>
);

const Ms2FileDetailsLayout = ({
  ms2FileDetails,
}: {
  ms2FileDetails: MS2FileDetails | undefined;
}) => {
  return (
    <Collapsible
      trigger={<span className="table-header-text">Imported MS2 Data</span>}
      hasBorder
    >
      <TableLayout
        title=""
        thead={[
          <th className="p-3">Description</th>,
          <th className="p-3">Value</th>,
        ]}
      >
        {Object.entries(FILE_DETAILS_MAP).map(([key, colName]) => (
          <Ms2FileDetailsRow
            description={colName}
            value={
              key === 'file_name' ? (
                <FileName>{ms2FileDetails?.mst?.[key] || ''}</FileName>
              ) : (
                ms2FileDetails?.mst?.[key]
              )
            }
          />
        ))}
      </TableLayout>
    </Collapsible>
  );
};

export default Ms2FileDetailsLayout;
