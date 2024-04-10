import styled from 'styled-components';

export const SectionTitle = styled.h1`
  font-style: normal;
  font-weight: 600;
  font-size: 18px;
  line-height: 27px;
  letter-spacing: 0.2px;
  color: #252f40;
  margin-bottom: 1.4em;
  display: flex;
  justify-content: space-between;
`;

export const Dashboard = styled.div`
  padding: 2rem;
`;

export const DashboardBottomRow = styled.div`
  display: flex;
  flex-direction: row;
`;

export const DashboardStatsTileTitle = styled.div`
  font-style: normal;
  font-weight: 600;
  font-size: 16px;
  line-height: 22px;
  /* identical to box height */

  color: #252f40;
`;

export const DashboardStatsCount = styled.div`
  font-weight: 700;
  font-size: 62px;
  line-height: 84px;
  color: #901a1e;
`;

export const RecentlyUploadedMS2 = styled.div`
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 400;
  font-size: 14px;
  line-height: 19px;
  text-decoration-line: underline;

  color: #901a1e;
  cursor: pointer;
`;

export const Separator = styled.div`
  border-top: 1px solid rgba(226, 226, 226, 0.25);
`;
