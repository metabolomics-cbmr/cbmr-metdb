import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import {
  CONTACTS,
  ISA_DOCUMENT_LICENSES,
  PUBLICATIONS,
} from '../../../../../shared/constants';
import { Investigation } from '../../../../../shared/model/investigation.model';
import Collapsible from '../../../../atoms/Collapsible';
import DatePickerInput from '../../../../atoms/DatePickerInput';
import Input from '../../../../atoms/Input';
import SelectBar from '../../../../atoms/SelectBar';
import TextArea from '../../../../atoms/TextArea';

const InvestigationFormGeneral = (props) => {
  const { currentActiveItem, investigation } = props;

  const generalRef = React.createRef<HTMLDivElement>();

  const [isOpen, setisOpen] = useState(false);

  useEffect(() => {
    if (currentActiveItem === investigation.id) {
      generalRef.current?.scrollIntoView();
      setisOpen(true);
    } else {
      setisOpen(false);
    }
  }, [currentActiveItem, investigation.id, generalRef]);

  return (
    <div className="investigation-form__general" ref={generalRef}>
      <Collapsible trigger="General Information" hasBorder isOpen={isOpen}>
        <Input label="Title" />

        {/* 20231119 LE */}
        <Input label="Identifier" />

        <Input label="Comment name" />
        <Input label="Comment Description" />


        <TextArea label="Description" />
        <div className="row">
          <div className="col-sm-12 col-lg-6 col-xl-4">
            <DatePickerInput label="Submission Date" />
          </div>
          <div className="col-sm-12 col-lg-6 col-xl-4">
            <DatePickerInput label="Public Release Date" />
          </div>
        </div>
        <SelectBar
          label={'Publications'}
          placeHolderText={'Publication'}
          options={PUBLICATIONS}
          multiple
        />
        <SelectBar
          label={'ISA Document Licenses'}
          placeHolderText={'ISA Document License'}
          options={ISA_DOCUMENT_LICENSES}
          multiple
        />
        <SelectBar
          label={'Contacts'}
          placeHolderText={'Contact'}
          options={CONTACTS}
          multiple
        />
      </Collapsible>
    </div>
  );
};

const mapStateToProps = (state: Investigation) => ({
  investigation: state,
  currentActiveItem: state.currentActiveItem,
});

export default connect(mapStateToProps)(InvestigationFormGeneral);
