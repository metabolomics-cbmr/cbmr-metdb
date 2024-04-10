import { useState } from 'react';
import { MS2CompoundPeak } from '../../../../shared/model/ms2file-details.model';
import Collapsible from '../../../atoms/Collapsible';
import LazyCollapsible from '../../../atoms/LazyCollapsible';
import TableLayout from '../../../layouts/TableLayout';

const MS2CompoundPeakRow = ({ id, index, mz, intensity }) => (
  <tr key={id} className="border-bottom">
    <th className="p-3 text-center" scope="row">
      {index + 1}
    </th>
    <td className="p-3">{mz}</td>
    <td className="p-3">{intensity}</td>
  </tr>
);

const MS2CompoundPeaks = ({ peaks }: { peaks: MS2CompoundPeak[] }) => {
  return (
    <div className="mt-5">
      <LazyCollapsible
        trigger={<span className="table-header-text">Peak Data</span>}
        hasBorder
      >
        <>
          <TableLayout
            title=""
            thead={[
              <th className="p-3 text-center">Sr No.</th>,
              <th className="p-3">MZ</th>,
              <th className="p-3">Intensity</th>,
            ]}
          >
            {peaks?.map?.((peak, index) => (
              <MS2CompoundPeakRow {...peak} index={index} />
            ))}
          </TableLayout>{' '}
        </>
      </LazyCollapsible>
    </div>
  );
};

export default MS2CompoundPeaks;
