"""Add table for compare settings and summary

Revision ID: 06538ebaaaaf
Revises: 781b1803672d
Create Date: 2023-04-02 10:11:02.371889

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '06538ebaaaaf'
down_revision = '781b1803672d'
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.create_table(
        'UnknownComparisonMisc',
        sa.Column('id', sa.BigInteger, autoincrement=True, primary_key=True),
        sa.Column('ms2mst_id', sa.BigInteger, nullable=False, primary_key=True),
        sa.Column('matching_peak_threshold', sa.Integer, nullable=False),
        sa.Column('matching_score_threshold', sa.Float, nullable=False),
        sa.Column('pep_mass_tolerance_from', sa.Integer, nullable=False),
        sa.Column('pep_mass_tolerance_to', sa.Integer, nullable=False),
        sa.Column('num_rows_processed', sa.Integer, nullable=False),
        sa.Column('num_unique_compounds', sa.Integer, nullable=False),
        sa.Column('num_rows_over_threshold', sa.Integer, nullable=False)
    )


def downgrade() -> None:
    pass
