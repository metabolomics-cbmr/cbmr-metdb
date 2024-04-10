"""Add number of spectra in ms2 mst

Revision ID: 781b1803672d
Revises: 93b29f9aa432
Create Date: 2023-04-01 12:52:19.827226

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '781b1803672d'
down_revision = '93b29f9aa432'
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.add_column('MS2Mst', sa.Column('num_spectra_in_file', sa.Integer))
    op.alter_column('MS2Mst', 'num_spectra_in_file', nullable=True)


def downgrade() -> None:
    pass
