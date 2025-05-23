import React from 'react';
import { ISidebarItem } from '../../../shared/model';
import ReactCollapsible from 'react-collapsible';

import './Sidebar.style.scss';
import { Link, useHistory } from 'react-router-dom';
import Logo from '../../../../assets/images/portal/logo.svg';
import { ROUTES } from '../../../Routes';

const SidebarItemTitle = (props) => {
  const { sidebarItem } = props;
  return (
    <div className="sidebar__item__text collapsible-trigger--inner">
      {sidebarItem.title}
      {sidebarItem.children?.length
        ? [
            <span className="sidebar-children-badge">
              {sidebarItem.children?.length}
            </span>,
            <span className="material-icons trigger-icon">
              keyboard_arrow_down
            </span>,
          ]
        : null}
    </div>
  );
};

const SidebarItemCollapsible = (props) => {
  const { sidebarItem } = props;
  const reactCollapsibleRef = React.createRef<ReactCollapsible>();
  const handleCollapsibleOpen = () => {
    (reactCollapsibleRef.current as any).innerRef.style.overflow = 'visible';
  };
  const handleCollapsibleClosing = () => {
    (reactCollapsibleRef.current as any).innerRef.style.overflow = 'hidden';
  };
  return (
    <ReactCollapsible
      trigger={<SidebarItemTitle sidebarItem={sidebarItem} />}
      onOpen={handleCollapsibleOpen}
      onClosing={handleCollapsibleClosing}
      ref={reactCollapsibleRef}
    >
      <SidebarItemChildren sidebarItem={sidebarItem} />
    </ReactCollapsible>
  );
};

const SidebarItemChildren = (props) => {
  const { sidebarItem } = props;
  return sidebarItem.children?.length
    ? sidebarItem.children.map((sidebarItemChild, index) => (
        <SidebarItem
          key={index}
          isActive={false}
          sidebarItem={sidebarItemChild}
          itemClick={() => {}}
        />
      ))
    : null;
};

const SidebarItem = (props: {
  sidebarItem: ISidebarItem;
  itemClick: any;
  isActive: boolean;
}) => {
  const { sidebarItem, itemClick = () => {}, isActive } = props;

  return (
    <div
      className={`sidebar__item ${
        isActive ? 'sidebar__item--active' : 'sidebar__item--inactive'
      }`}
      onClick={() => itemClick(sidebarItem)}
    >
      {sidebarItem.children?.length ? (
        <SidebarItemCollapsible sidebarItem={sidebarItem} />
      ) : (
        <SidebarItemTitle sidebarItem={sidebarItem} />
      )}
    </div>
  );
};

const Sidebar = (props: {
  sidebarItems?: ISidebarItem[];
  itemClick?: any;
  activeItem?: ISidebarItem;
  children?: React.ReactChildren | any;
}) => {
  const { sidebarItems = [], itemClick, activeItem, children } = props;
  const history = useHistory();
  return (
    <div className="sidebar--inner">
      <Link to={ROUTES.DASHBOARD}>
        <div className="site-title">
          <img src={Logo} alt="logo" className="site-title__logo" />
          <span className="site-title__text">CBMR Metabolomics Database</span>
        </div>
      </Link>
      <div className="sidebar__items">
        {sidebarItems.map((sidebarItem: ISidebarItem, index) => (
          <SidebarItem
            key={sidebarItem.id || index}
            isActive={activeItem?.id === sidebarItem.id}
            sidebarItem={sidebarItem}
            itemClick={
              itemClick ||
              (() => {
                history.push(sidebarItem.href);
              })
            }
          />
        ))}
      </div>
      {children}
    </div>
  );
};

export default Sidebar;
