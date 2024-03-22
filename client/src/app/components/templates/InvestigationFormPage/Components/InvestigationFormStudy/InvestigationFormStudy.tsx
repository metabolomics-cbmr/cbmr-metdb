import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import {
  CONTACTS,
  DESIGN_TYPES,
  FACTOR_TYPES,
  PROTOCOLS,
  PUBLICATIONS,
  STUDY_TYPES,
} from '../../../../../shared/constants';
import {
  Investigation,
  Study,
} from '../../../../../shared/model/investigation.model';
import {
  setCurrentActiveItem,
  setStudyTitle,
} from '../../../../../shared/redux/actions';
import Badge from '../../../../atoms/Badge';
import ButtonToggle from '../../../../atoms/ButtonToggle';
import Collapsible from '../../../../atoms/Collapsible';
import DeleteIcon from '../../../../atoms/DeleteIcon';
import Input from '../../../../atoms/Input';
import SelectBar from '../../../../atoms/SelectBar';
import TextArea from '../../../../atoms/TextArea';
import InvestigationFormAssays from '../InvestigationFormAssays';
import './InvestigationFormStudy.style.scss';

const InvestigationStudyTitle = (props: {
  study: Study;
  deleteStudy;
  onClick;
}) => {
  const { study, deleteStudy, onClick } = props;
  return (
    <div className="study__title" onClick={onClick}>
      <div className="study__title--text">{study.title || 'New Study'}</div>
      <div className="study__title__cta">
        <div className="study__delete">
          <DeleteIcon onClick={deleteStudy} />
        </div>
        <div className="study__assay-count">
          <Badge isActive={true}>{study.assays.length} Assay</Badge>
        </div>
      </div>
    </div>
  );
};

const InvestigationFormStudy = (props: {
  study: Study;
  deleteStudy;
  setStudyTitle?: any;
  currentActiveItem?: string;
  setCurrentActiveItem: Function;
}) => {
  const {
    study,
    deleteStudy,
    setStudyTitle,
    currentActiveItem,
    setCurrentActiveItem,
  } = props;
  const handleStudyTitleChange = (title) => {
    setStudyTitle(study, title);
  };
  const studyRef = React.createRef<HTMLDivElement>();
  const [isOpen, setIsOpen] = useState(false);
  useEffect(() => {
    if (currentActiveItem === study.id) {
      studyRef.current?.scrollIntoView();
      setIsOpen(true);
    } else {
      setIsOpen(false);
    }
  }, [currentActiveItem, study.id, studyRef]);

  const handleCollapsibleClick = () => {
    setIsOpen(!isOpen);
    setCurrentActiveItem(isOpen ? null : study.id);
  };

  return (
    <div className="investigation-form__study" ref={studyRef}>
      <Collapsible
        id={study.id}
        isOpen={isOpen}
        trigger={
          <InvestigationStudyTitle
            study={study}
            deleteStudy={deleteStudy}
            onClick={handleCollapsibleClick}
          />
        }
        hasBorder
      >
        <Input label="Title" onChange={handleStudyTitleChange} />

        <Input label="Identifier"/>

        <TextArea label="Description" />
        <SelectBar
          label={'Publications'}
          placeHolderText={'Publication'}
          options={PUBLICATIONS}
          multiple
        />
        <SelectBar
          label={'Contacts'}
          placeHolderText={'Contact'}
          options={CONTACTS}
          multiple
        />
        <ButtonToggle
          label="Study Type"
          items={STUDY_TYPES}
          value={STUDY_TYPES[0]}
          labelKey="studyName"
        />
        <SelectBar
          label={'Design Type'}
          placeHolderText={'Design Type'}
          options={DESIGN_TYPES}
        />
        <Input label="Factor Name" />
        <SelectBar
          label={'Factor Type'}
          placeHolderText={'Factor Type'}
          options={FACTOR_TYPES}
        />
        <SelectBar
          label={'Protocols'}
          placeHolderText={'Protocols'}
          options={PROTOCOLS}
          multiple
        />
        <InvestigationFormAssays study={study} />
      </Collapsible>
    </div>
  );
};

const mapStateToProps = (state: Investigation) => ({
  currentActiveItem: state.currentActiveItem,
});

const mapDispatchToProps = (dispatch) => ({
  setCurrentActiveItem: (itemId) => dispatch(setCurrentActiveItem(itemId)),
  setStudyTitle: (study, title) => dispatch(setStudyTitle(study, title)),
});

export default connect(
  mapStateToProps,
  mapDispatchToProps,
)(InvestigationFormStudy);
