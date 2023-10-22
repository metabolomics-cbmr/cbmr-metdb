import { useState } from 'react';
import { connect } from 'react-redux';
import { ISidebarItem } from '../../../../../shared/model';
import { Investigation } from '../../../../../shared/model/investigation.model';
import { setCurrentActiveItem } from '../../../../../shared/redux/actions';
import Sidebar from '../../../../organisms/Sidebar';

const InvestigationFormSidebar = (props) => {
  const { investigation, setCurrentActiveItem, currentActiveItem } = props;
  const InvestigationFormSidebarItems: ISidebarItem[] = [
    {
      id: investigation.id,
      icon: '',
      title: 'General Information',
      href: '#general',
    },
  ];
  const [activeItem, setActiveItem] = useState(
    InvestigationFormSidebarItems[0],
  );

  InvestigationFormSidebarItems.push(
    ...(investigation as Investigation).studies.map((study) => ({
      id: study.id,
      icon: '',
      title: study.title || 'New Study',
      href: '',
      children: study.assays.map((assay) => ({
        id: assay.id,
        title: assay.title || 'New Assay',
        href: '',
        icon: '',
      })),
    })),
  );

  const itemClick = (item: ISidebarItem) => {
    if (currentActiveItem !== item.id) {
      setActiveItem(item);
      setCurrentActiveItem(item.id);
    } else {
      setActiveItem(InvestigationFormSidebarItems[0]);
      setCurrentActiveItem(null);
    }
  };
  return (
    <Sidebar
      sidebarItems={InvestigationFormSidebarItems}
      itemClick={itemClick}
    />
  );
};

const mapStateToProps = (state: Investigation) => ({
  investigation: state,
  currentActiveItem: state.currentActiveItem,
});

const mapDispatchToProps = (dispatch) => ({
  setCurrentActiveItem: (itemId) => dispatch(setCurrentActiveItem(itemId)),
});

export default connect(
  mapStateToProps,
  mapDispatchToProps,
)(InvestigationFormSidebar);
