import { useState } from 'react';
import './UnknownCompoundDetectionSettings.style.scss';
import { Button } from 'react-bootstrap';
import { ComparisionSettings } from '../../../../../shared/model/comparision.model';
import { saveComparisionSettings } from '../../../../../shared/utils/api.utils';
import DataTable, { TableColumn } from 'react-data-table-component';
import ModalWrapper from '../../../../organisms/ModalWrapper/ModalWrapper';
import useComparisonSettings from '../../../../../shared/hooks/useComparisonSettings';
import UnknownCompoundDetectionConfig from '../UnknownCompoundDetectionConfig/UnknownCompoundDetectionConfig';

const NewComparisionSetting = ({ hideAddConfigModal, onConfigAdd }) => {
  const [comparisionSettings, setComparisionSettings] = useState({
    name: '',
    matching_peaks: '1',
    matching_score: '0.75',
    pep_mass_tolerance: [-1, 1],
  });

  const isSaveButtonEnabled = () =>
    Object.values(comparisionSettings).every((value) => value);

  const updateComparisonSettings = (updatedSettings) => {
    setComparisionSettings({ ...comparisionSettings, ...updatedSettings });
  };

  const saveSettings = async () => {
    try {
      const { name, matching_peaks, matching_score, pep_mass_tolerance } =
        comparisionSettings;
      const [pepmass_tolerance_from, pepmass_tolerance_to] = pep_mass_tolerance;
      const apiObject = {
        name,
        matching_peaks,
        matching_score,
        pepmass_tolerance_from,
        pepmass_tolerance_to,
      };
      await saveComparisionSettings(apiObject);
      hideAddConfigModal();
      onConfigAdd();
    } catch (error: any) {
      console.log('CONFIG_SAVE_ERROR', error);
      alert(
        JSON.parse(error.message)?.body?.description ||
          'Could not save your config.',
      );
    }
  };

  return (
    <ModalWrapper
      title="Add New Config for Unknown Compound Detection"
      onCancel={hideAddConfigModal}
      saveButtonText={'Save'}
      isSaveEnabled={isSaveButtonEnabled()}
      onClickSave={saveSettings}
    >
      <UnknownCompoundDetectionConfig
        comparisionSettings={comparisionSettings}
        updateComparisonSettings={updateComparisonSettings}
      />
    </ModalWrapper>
  );
};

const SavedComparisionSettings = ({
  comparisionSettings,
  changeConfigStatus,
}: {
  comparisionSettings: ComparisionSettings[];
  changeConfigStatus: (config: ComparisionSettings) => {};
}) => {
  const columns: TableColumn<ComparisionSettings>[] = [
    {
      name: '#',
      cell: (row: ComparisionSettings, index, column) => index + 1,
    },
    {
      name: 'Name',
      selector: (row: ComparisionSettings) => row.name,
      sortable: true,
      id: 'name',
    },
    {
      name: 'Minimum number of matching peaks',
      selector: (row: ComparisionSettings) => row.config.matching_peaks,
      id: 'matching_peaks',
    },
    {
      name: 'Matching score threshold',
      selector: (row: ComparisionSettings) => row.config.matching_score,
      id: 'matching_score',
    },
    {
      name: 'Precursor mass tolerance for selecting reference compounds',
      selector: (row: ComparisionSettings) =>
        `${row.config.pep_mass_tolerance[0]} to ${row.config.pep_mass_tolerance[1]}`,
      id: 'pep_mass_tolerance',
    },
    {
      name: 'Date Created',
      sortable: true,
      selector: (row: ComparisionSettings) =>
        row.date || new Date().toLocaleDateString(),
      id: 'date',
    },
    {
      name: 'ChangeStatus',
      cell: (row: ComparisionSettings) => (
        <u
          className="bottom-text cursor-pointer"
          onClick={() => changeConfigStatus(row)}
        >
          {row.active ? 'Deactivate' : 'Activate'}
        </u>
      ),
      id: 'changeStatus',
    },
  ];

  return (
    <div className="border rounded">
      <DataTable
        columns={columns}
        data={comparisionSettings.filter((config) => config.active)}
      />
    </div>
  );
};

const UnknownCompoundDetectionSettings = (props) => {
  const [addConfigModal, setAddConfigModal] = useState(false);

  const {
    comparisionSettings,
    getComparisionSettingsFromAPI,
    changeConfigStatus,
  } = useComparisonSettings();

  const showAddConfigModal = () => {
    setAddConfigModal(true);
  };

  const hideAddConfigModal = () => {
    setAddConfigModal(false);
  };

  const onConfigAdd = () => {
    getComparisionSettingsFromAPI();
  };

  return (
    <div className="unknown-compoune-detection-settings">
      <div className="text-right mb-4">
        <Button onClick={showAddConfigModal}>Add New Config</Button>
      </div>
      <SavedComparisionSettings
        comparisionSettings={comparisionSettings}
        changeConfigStatus={changeConfigStatus}
      />
      {addConfigModal ? (
        <NewComparisionSetting
          hideAddConfigModal={hideAddConfigModal}
          onConfigAdd={onConfigAdd}
        />
      ) : null}
    </div>
  );
};

export default UnknownCompoundDetectionSettings;
