import { MS2FileCompound } from '../../../../shared/model/ms2file-details.model';
import Collapsible from '../../../atoms/Collapsible';
import { Tick, Cross, Plus, Minus } from '../../../atoms/Icons';
import TableLayout from '../../../layouts/TableLayout';
import { SCAN_DETAILS_MAP } from '../MS2FileInfo.const';

const useScanValue = (scanKey) => {
  let value = scanKey;
  switch (scanKey) {
    case 'centroided':
      value = scanKey ? <Tick /> : <Cross />;
      break;
    case 'polarity':
      value = scanKey ? <Plus /> : <Minus />;
      break;
    default:
      value = scanKey;
  }
  return value;
};

const ScanDetailsRow = ({
  scanKey,
  scanRow,
  colName,
}: {
  scanKey: string;
  scanRow: MS2FileCompound;
  colName: string;
}) => {
  const [detailKey] = scanRow?.det || [];
  const value = useScanValue(detailKey?.[scanKey]);
  return (
    <tr key={scanKey} className="border-bottom">
      <th scope="row" className="p-3">
        {colName}
      </th>
      <td className="p-3">{value}</td>
    </tr>
  );
};

const MS2CompoundScanDetails = ({
  ms2FileCompound,
}: {
  ms2FileCompound: MS2FileCompound;
}) => {
  return (
    <div className="mt-5">
      <Collapsible
        trigger={<span className="table-header-text">Scan Details</span>}
        hasBorder
      >
        <>
          <TableLayout
            title=""
            thead={[
              <th className="p-3">Description</th>,
              <th className="p-3">Value</th>,
            ]}
          >
            {Object.entries(SCAN_DETAILS_MAP).map(([key, colName]) => (
              <ScanDetailsRow
                key={key}
                colName={colName}
                scanKey={key}
                scanRow={ms2FileCompound}
              />
            ))}
          </TableLayout>
        </>
      </Collapsible>
    </div>
  );
};

export default MS2CompoundScanDetails;
