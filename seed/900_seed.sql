-- ResearchFrontier — DEV/DEMO seed.
-- Purpose: make `docker compose up` show a populated UI with no network and no
-- API keys. It mirrors the OpenAlex hierarchy with REAL display names but the
-- ids are illustrative. In a real deployment you run the taxonomy sync + paper
-- ingestion jobs (the source of truth) instead of loading this file; do not mix
-- this seed with a live sync in the same database.

-- ---------- Taxonomy ----------
INSERT INTO domain (id, openalex_id, display_name) VALUES
    (1, 'https://openalex.org/domains/1', 'Physical Sciences'),
    (2, 'https://openalex.org/domains/2', 'Life Sciences'),
    (3, 'https://openalex.org/domains/3', 'Social Sciences'),
    (4, 'https://openalex.org/domains/4', 'Health Sciences')
ON CONFLICT (id) DO NOTHING;

INSERT INTO field (id, openalex_id, display_name, domain_id) VALUES
    (17, 'https://openalex.org/fields/17', 'Computer Science', 1),
    (31, 'https://openalex.org/fields/31', 'Physics and Astronomy', 1),
    (26, 'https://openalex.org/fields/26', 'Mathematics', 1),
    (27, 'https://openalex.org/fields/27', 'Medicine', 4),
    (13, 'https://openalex.org/fields/13', 'Biochemistry, Genetics and Molecular Biology', 2),
    (20, 'https://openalex.org/fields/20', 'Economics, Econometrics and Finance', 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO subfield (id, openalex_id, display_name, field_id) VALUES
    (1702, 'https://openalex.org/subfields/1702', 'Artificial Intelligence', 17),
    (1707, 'https://openalex.org/subfields/1707', 'Computer Vision and Pattern Recognition', 17),
    (1705, 'https://openalex.org/subfields/1705', 'Computer Networks and Communications', 17),
    (3103, 'https://openalex.org/subfields/3103', 'Astronomy and Astrophysics', 31),
    (2730, 'https://openalex.org/subfields/2730', 'Oncology', 27),
    (2705, 'https://openalex.org/subfields/2705', 'Cardiology and Cardiovascular Medicine', 27),
    (1312, 'https://openalex.org/subfields/1312', 'Molecular Biology', 13),
    (2002, 'https://openalex.org/subfields/2002', 'Economics and Econometrics', 20)
ON CONFLICT (id) DO NOTHING;

INSERT INTO topic (id, openalex_id, display_name, subfield_id, keywords) VALUES
    (10001, 'https://openalex.org/T10001', 'Large Language Models and Alignment', 1702, ARRAY['LLM','alignment','RLHF','instruction tuning']),
    (10002, 'https://openalex.org/T10002', 'Reinforcement Learning Methods', 1702, ARRAY['RL','policy optimization','agents']),
    (10003, 'https://openalex.org/T10003', 'Graph Neural Networks', 1702, ARRAY['GNN','graph learning','message passing']),
    (11001, 'https://openalex.org/T11001', 'Generative Image and Video Models', 1707, ARRAY['diffusion','GAN','text-to-image']),
    (11002, 'https://openalex.org/T11002', '3D Scene Reconstruction', 1707, ARRAY['NeRF','gaussian splatting','SfM']),
    (12001, 'https://openalex.org/T12001', 'Federated and Edge Learning', 1705, ARRAY['federated learning','edge','privacy']),
    (31001, 'https://openalex.org/T31001', 'Exoplanet Detection and Characterization', 3103, ARRAY['exoplanets','transit','radial velocity']),
    (31002, 'https://openalex.org/T31002', 'Gravitational Wave Astronomy', 3103, ARRAY['LIGO','black holes','mergers']),
    (27001, 'https://openalex.org/T27001', 'Cancer Immunotherapy and Checkpoint Inhibitors', 2730, ARRAY['immunotherapy','PD-1','CAR-T']),
    (27002, 'https://openalex.org/T27002', 'Liquid Biopsy and Circulating Tumor DNA', 2730, ARRAY['ctDNA','liquid biopsy','early detection']),
    (27051, 'https://openalex.org/T27051', 'Heart Failure Management', 2705, ARRAY['heart failure','SGLT2','cardiology']),
    (13001, 'https://openalex.org/T13001', 'CRISPR Gene Editing', 1312, ARRAY['CRISPR','base editing','prime editing']),
    (20001, 'https://openalex.org/T20001', 'Causal Inference in Economics', 2002, ARRAY['causal inference','difference-in-differences','instrumental variables'])
ON CONFLICT (id) DO NOTHING;

-- ---------- Works ----------
-- review_status: peer_reviewed | preprint_published | preprint | retracted | unknown
INSERT INTO work
    (id, openalex_id, doi, published_doi, title, abstract, authors,
     publication_date, publication_year, ingested_date, language, cited_by_count,
     primary_source_name, primary_source_type, openalex_type, crossref_type,
     landing_page_url, pdf_url, is_oa, is_retracted,
     review_status, review_confidence, review_evidence,
     primary_topic_id, primary_subfield_id, primary_field_id, primary_domain_id)
VALUES
    (1, 'https://openalex.org/W4400000001', '10.48550/arxiv.2610.00123', NULL,
     'Self-Refining Alignment: Closing the Feedback Loop for Large Language Models',
     'We introduce a self-refining alignment procedure that reduces reliance on human preference labels while improving instruction-following on held-out tasks.',
     '[{"name":"L. Moreau","position":"first"},{"name":"A. Rossi","position":"middle"},{"name":"K. Tanaka","position":"last"}]',
     '2026-10-05', 2026, '2026-10-06', 'en', 3,
     'arXiv', 'repository', 'preprint', 'posted-content',
     'https://arxiv.org/abs/2610.00123', 'https://arxiv.org/pdf/2610.00123', TRUE, FALSE,
     'preprint', 'high', '{"source_type":"repository","openalex_type":"preprint","arxiv":true}',
     10001, 1702, 17, 1),

    (2, 'https://openalex.org/W4400000002', '10.1038/s41586-026-00001-2', NULL,
     'Scaling Laws for Tool-Using Agents under Bounded Compute',
     'A systematic study of how tool-using language agents scale with model size, context length and interaction budget.',
     '[{"name":"R. Khan","position":"first"},{"name":"M. Oliveira","position":"last"}]',
     '2026-09-28', 2026, '2026-09-30', 'en', 11,
     'Nature', 'journal', 'article', 'journal-article',
     'https://www.nature.com/articles/s41586-026-00001-2', NULL, FALSE, FALSE,
     'peer_reviewed', 'high', '{"source_type":"journal","version":"publishedVersion","indexed_in":["crossref","doaj"]}',
     10002, 1702, 17, 1),

    (3, 'https://openalex.org/W4400000003', '10.48550/arxiv.2609.04567', '10.1109/tpami.2026.0003',
     'Message Passing Is All You Need, Again: A Unified View of Graph Learning',
     'We reconcile competing graph neural network families under a single message-passing formalism and show when each is optimal.',
     '[{"name":"S. Park","position":"first"},{"name":"D. Verdi","position":"middle"},{"name":"H. Weiss","position":"last"}]',
     '2026-09-20', 2026, '2026-09-22', 'en', 25,
     'IEEE TPAMI', 'journal', 'article', 'journal-article',
     'https://doi.org/10.1109/tpami.2026.0003', NULL, FALSE, FALSE,
     'preprint_published', 'high', '{"preprint":"arxiv","published_version":"journal","relation":"is-preprint-of"}',
     10003, 1702, 17, 1),

    (4, 'https://openalex.org/W4400000004', '10.48550/arxiv.2610.01999', NULL,
     'Consistency-Distilled Diffusion for Real-Time Text-to-Video',
     'A distillation scheme that generates coherent short videos from text prompts at interactive frame rates on a single GPU.',
     '[{"name":"Y. Chen","position":"first"},{"name":"P. Novak","position":"last"}]',
     '2026-10-02', 2026, '2026-10-03', 'en', 6,
     'arXiv', 'repository', 'preprint', 'posted-content',
     'https://arxiv.org/abs/2610.01999', 'https://arxiv.org/pdf/2610.01999', TRUE, FALSE,
     'preprint', 'high', '{"source_type":"repository","openalex_type":"preprint","arxiv":true}',
     11001, 1707, 17, 1),

    (5, 'https://openalex.org/W4400000005', '10.1109/cvpr.2026.00512', NULL,
     'Gaussian Splatting at City Scale with Streaming Level-of-Detail',
     'We extend 3D Gaussian splatting to kilometer-scale scenes with a streaming level-of-detail representation.',
     '[{"name":"F. Bianchi","position":"first"},{"name":"T. Hoffmann","position":"last"}]',
     '2026-09-26', 2026, '2026-09-27', 'en', 14,
     'CVPR 2026', 'conference', 'article', 'proceedings-article',
     'https://doi.org/10.1109/cvpr.2026.00512', NULL, TRUE, FALSE,
     'peer_reviewed', 'medium', '{"source_type":"conference","crossref_type":"proceedings-article"}',
     11002, 1707, 17, 1),

    (6, 'https://openalex.org/W4400000006', '10.48550/arxiv.2610.00777', NULL,
     'Privacy-Preserving Federated Learning on Heterogeneous Edge Devices',
     'A communication-efficient federated protocol with formal differential-privacy guarantees across heterogeneous hardware.',
     '[{"name":"N. Gupta","position":"first"},{"name":"E. Laurent","position":"last"}]',
     '2026-10-04', 2026, '2026-10-05', 'en', 2,
     'arXiv', 'repository', 'preprint', 'posted-content',
     'https://arxiv.org/abs/2610.00777', 'https://arxiv.org/pdf/2610.00777', TRUE, FALSE,
     'preprint', 'high', '{"source_type":"repository","openalex_type":"preprint","arxiv":true}',
     12001, 1705, 17, 1),

    (7, 'https://openalex.org/W4400000007', '10.3847/1538-4357/ad0007', NULL,
     'A Temperate Sub-Neptune in the Habitable Zone of a Nearby M Dwarf',
     'JWST transmission spectroscopy reveals a water-rich atmosphere on a temperate sub-Neptune 12 parsecs away.',
     '[{"name":"C. Alvarez","position":"first"},{"name":"J. Smith","position":"middle"},{"name":"R. Oyelaran","position":"last"}]',
     '2026-09-18', 2026, '2026-09-21', 'en', 33,
     'The Astrophysical Journal', 'journal', 'article', 'journal-article',
     'https://doi.org/10.3847/1538-4357/ad0007', NULL, TRUE, FALSE,
     'peer_reviewed', 'high', '{"source_type":"journal","version":"publishedVersion","indexed_in":["crossref"]}',
     31001, 3103, 31, 1),

    (8, 'https://openalex.org/W4400000008', '10.48550/arxiv.2610.02222', NULL,
     'A Candidate Intermediate-Mass Black Hole Merger in the O5 Run',
     'We report a gravitational-wave candidate consistent with an intermediate-mass black hole binary merger.',
     '[{"name":"LVK Collaboration","position":"first"}]',
     '2026-10-06', 2026, '2026-10-07', 'en', 1,
     'arXiv', 'repository', 'preprint', 'posted-content',
     'https://arxiv.org/abs/2610.02222', 'https://arxiv.org/pdf/2610.02222', TRUE, FALSE,
     'preprint', 'high', '{"source_type":"repository","openalex_type":"preprint","arxiv":true}',
     31002, 3103, 31, 1),

    (9, 'https://openalex.org/W4400000009', '10.1056/nejmoa2600001', NULL,
     'Dual Checkpoint Blockade in Treatment-Naive Metastatic Melanoma: A Phase 3 Trial',
     'In a randomized phase 3 trial, dual checkpoint blockade improved overall survival versus monotherapy in metastatic melanoma.',
     '[{"name":"A. Ferraro","position":"first"},{"name":"B. Lindqvist","position":"last"}]',
     '2026-09-24', 2026, '2026-09-25', 'en', 19,
     'New England Journal of Medicine', 'journal', 'article', 'journal-article',
     'https://doi.org/10.1056/nejmoa2600001', NULL, FALSE, FALSE,
     'peer_reviewed', 'high', '{"source_type":"journal","version":"publishedVersion","indexed_in":["crossref","pubmed"]}',
     27001, 2730, 27, 4),

    (10, 'https://openalex.org/W4400000010', '10.1101/2026.09.15.600001', NULL,
     'Multi-Cancer Early Detection from Cell-Free DNA Methylation at Population Scale',
     'A prospective study evaluates a methylation-based liquid biopsy for multi-cancer early detection in an asymptomatic cohort.',
     '[{"name":"G. Romano","position":"first"},{"name":"W. Zhang","position":"last"}]',
     '2026-09-15', 2026, '2026-09-16', 'en', 4,
     'medRxiv', 'repository', 'preprint', 'posted-content',
     'https://www.medrxiv.org/content/10.1101/2026.09.15.600001', 'https://www.medrxiv.org/content/10.1101/2026.09.15.600001.full.pdf', TRUE, FALSE,
     'preprint', 'high', '{"source_type":"repository","openalex_type":"preprint","server":"medRxiv"}',
     27002, 2730, 27, 4),

    (11, 'https://openalex.org/W4400000011', '10.1161/circulationaha.126.060001', NULL,
     'SGLT2 Inhibition in Heart Failure with Preserved Ejection Fraction: 2-Year Outcomes',
     'Extended follow-up confirms sustained reduction in heart-failure hospitalizations with SGLT2 inhibition in HFpEF.',
     '[{"name":"M. Costa","position":"first"},{"name":"I. Nowak","position":"last"}]',
     '2026-09-30', 2026, '2026-10-01', 'en', 7,
     'Circulation', 'journal', 'article', 'journal-article',
     'https://doi.org/10.1161/circulationaha.126.060001', NULL, FALSE, FALSE,
     'peer_reviewed', 'high', '{"source_type":"journal","version":"publishedVersion","indexed_in":["crossref","pubmed"]}',
     27051, 2705, 27, 4),

    (12, 'https://openalex.org/W4400000012', '10.1016/j.cell.2026.09.010', '10.1016/j.cell.2026.09.010',
     'Prime Editing Corrects a Pathogenic Variant in Human Hematopoietic Stem Cells',
     'We achieve efficient, low-off-target prime editing of a disease variant in primary human hematopoietic stem cells.',
     '[{"name":"K. Nguyen","position":"first"},{"name":"O. Haddad","position":"last"}]',
     '2026-09-22', 2026, '2026-09-23', 'en', 21,
     'Cell', 'journal', 'article', 'journal-article',
     'https://doi.org/10.1016/j.cell.2026.09.010', NULL, FALSE, FALSE,
     'peer_reviewed', 'high', '{"source_type":"journal","version":"publishedVersion","indexed_in":["crossref","pubmed"]}',
     13001, 1312, 13, 2),

    (13, 'https://openalex.org/W4400000013', '10.48550/arxiv.2609.09001', NULL,
     'Robust Difference-in-Differences under Staggered Adoption and Heterogeneous Effects',
     'A new estimator for staggered-adoption designs that is robust to treatment-effect heterogeneity.',
     '[{"name":"D. Serra","position":"first"},{"name":"P. Andersson","position":"last"}]',
     '2026-09-12', 2026, '2026-09-14', 'en', 9,
     'arXiv', 'repository', 'preprint', 'posted-content',
     'https://arxiv.org/abs/2609.09001', 'https://arxiv.org/pdf/2609.09001', TRUE, FALSE,
     'preprint', 'high', '{"source_type":"repository","openalex_type":"preprint","arxiv":true}',
     20001, 2002, 20, 3),

    (14, 'https://openalex.org/W4400000014', '10.5555/retracted.2026.0001', NULL,
     'Room-Temperature Superconductivity in a Nitrogen-Doped Lattice (RETRACTED)',
     'This article has been retracted following failures to reproduce the central measurements.',
     '[{"name":"X. Volkov","position":"first"}]',
     '2026-09-10', 2026, '2026-09-11', 'en', 48,
     'Journal of Applied Physics Letters', 'journal', 'article', 'journal-article',
     'https://doi.org/10.5555/retracted.2026.0001', NULL, FALSE, TRUE,
     'retracted', 'high', '{"is_retracted":true,"crossref_update_type":"retraction","confirmed_by":"crossref"}',
     31002, 3103, 31, 1),

    (15, 'https://openalex.org/W4400000015', '10.48550/arxiv.2610.01010', NULL,
     'Mechanistic Interpretability of Reward Models via Sparse Feature Circuits',
     'We extract human-interpretable feature circuits from reward models and link them to specific preference behaviors.',
     '[{"name":"J. Fischer","position":"first"},{"name":"Q. Li","position":"last"}]',
     '2026-10-07', 2026, '2026-10-08', 'en', 0,
     'arXiv', 'repository', 'preprint', 'posted-content',
     'https://arxiv.org/abs/2610.01010', 'https://arxiv.org/pdf/2610.01010', TRUE, FALSE,
     'preprint', 'high', '{"source_type":"repository","openalex_type":"preprint","arxiv":true}',
     10001, 1702, 17, 1),

    (16, 'https://openalex.org/W4400000016', '10.1145/3600000.3600016', NULL,
     'Offline-to-Online Reinforcement Learning for Data-Center Cooling',
     'A hybrid offline-to-online RL controller cuts data-center cooling energy while respecting safety constraints.',
     '[{"name":"R. Esposito","position":"first"},{"name":"S. Mbeki","position":"last"}]',
     '2026-09-29', 2026, '2026-09-30', 'en', 5,
     'ACM Transactions on Intelligent Systems', 'journal', 'article', 'journal-article',
     'https://doi.org/10.1145/3600000.3600016', NULL, FALSE, FALSE,
     'peer_reviewed', 'medium', '{"source_type":"journal","crossref_type":"journal-article"}',
     10002, 1702, 17, 1),

    (17, 'https://openalex.org/W4400000017', NULL, NULL,
     'A Preliminary Benchmark for Long-Horizon Scientific Agents',
     'We propose an early benchmark for evaluating language agents on multi-day scientific workflows.',
     '[{"name":"T. Brambilla","position":"first"}]',
     '2026-10-01', 2026, '2026-10-02', 'en', 0,
     'Zenodo', 'repository', 'other', NULL,
     'https://zenodo.org/records/26000017', NULL, TRUE, FALSE,
     'unknown', 'low', '{"reason":"no DOI resolved, repository other-type, status unverified"}',
     10002, 1702, 17, 1),

    (18, 'https://openalex.org/W4400000018', '10.48550/arxiv.2610.02550', NULL,
     'Direct Imaging of a Protoplanet Gap with the Extremely Large Telescope',
     'First-light ELT observations resolve a gap carved by an accreting protoplanet in a nearby disk.',
     '[{"name":"H. Ito","position":"first"},{"name":"M. Dubois","position":"last"}]',
     '2026-10-03', 2026, '2026-10-04', 'en', 2,
     'arXiv', 'repository', 'preprint', 'posted-content',
     'https://arxiv.org/abs/2610.02550', 'https://arxiv.org/pdf/2610.02550', TRUE, FALSE,
     'preprint', 'high', '{"source_type":"repository","openalex_type":"preprint","arxiv":true}',
     31001, 3103, 31, 1),

    (19, 'https://openalex.org/W4400000019', '10.1200/jco.26.00019', NULL,
     'CAR-T Therapy Durability in Relapsed B-Cell Lymphoma: 5-Year Real-World Data',
     'A multicenter real-world analysis reports long-term remission rates and late toxicities of CAR-T in B-cell lymphoma.',
     '[{"name":"L. Moretti","position":"first"},{"name":"V. Olsson","position":"last"}]',
     '2026-09-19', 2026, '2026-09-20', 'en', 12,
     'Journal of Clinical Oncology', 'journal', 'article', 'journal-article',
     'https://doi.org/10.1200/jco.26.00019', NULL, FALSE, FALSE,
     'peer_reviewed', 'high', '{"source_type":"journal","version":"publishedVersion","indexed_in":["crossref","pubmed"]}',
     27001, 2730, 27, 4),

    (20, 'https://openalex.org/W4400000020', '10.1101/2026.10.01.700020', '10.1038/s41591-026-00020-9',
     'Wearable-Derived Cardiac Biomarkers Predict Heart-Failure Decompensation',
     'A preprint, now published, showing wearable-derived biomarkers forecast decompensation days in advance.',
     '[{"name":"A. Petrova","position":"first"},{"name":"C. Nakamura","position":"last"}]',
     '2026-09-16', 2026, '2026-09-17', 'en', 8,
     'medRxiv', 'repository', 'preprint', 'posted-content',
     'https://www.medrxiv.org/content/10.1101/2026.10.01.700020', NULL, TRUE, FALSE,
     'preprint_published', 'high', '{"preprint":"medrxiv","published_version":"journal","relation":"is-preprint-of"}',
     27051, 2705, 27, 4)
ON CONFLICT (id) DO NOTHING;

SELECT setval(pg_get_serial_sequence('work', 'id'), (SELECT COALESCE(MAX(id), 1) FROM work));

-- work_topic (primary topic per work; a couple of multi-topic works)
INSERT INTO work_topic (work_id, topic_id, score, is_primary) VALUES
    (1, 10001, 0.94, TRUE), (1, 10002, 0.41, FALSE),
    (2, 10002, 0.90, TRUE), (2, 10001, 0.52, FALSE),
    (3, 10003, 0.96, TRUE),
    (4, 11001, 0.93, TRUE),
    (5, 11002, 0.91, TRUE), (5, 11001, 0.38, FALSE),
    (6, 12001, 0.92, TRUE),
    (7, 31001, 0.95, TRUE),
    (8, 31002, 0.93, TRUE),
    (9, 27001, 0.96, TRUE),
    (10, 27002, 0.90, TRUE),
    (11, 27051, 0.95, TRUE),
    (12, 13001, 0.97, TRUE),
    (13, 20001, 0.92, TRUE),
    (14, 31002, 0.70, TRUE),
    (15, 10001, 0.89, TRUE), (15, 10003, 0.33, FALSE),
    (16, 10002, 0.88, TRUE),
    (17, 10002, 0.55, TRUE),
    (18, 31001, 0.90, TRUE),
    (19, 27001, 0.94, TRUE),
    (20, 27051, 0.91, TRUE)
ON CONFLICT DO NOTHING;

-- A few alternate identifiers (dedup store)
INSERT INTO work_identifier (work_id, scheme, value) VALUES
    (1, 'arxiv', '2610.00123'), (1, 'doi', '10.48550/arxiv.2610.00123'),
    (3, 'arxiv', '2609.04567'), (3, 'doi', '10.1109/tpami.2026.0003'),
    (9, 'doi', '10.1056/nejmoa2600001'), (9, 'pmid', '40000009'),
    (20, 'doi', '10.1101/2026.10.01.700020'), (20, 'doi', '10.1038/s41591-026-00020-9')
ON CONFLICT DO NOTHING;

-- Refresh denormalized works_count on taxonomy nodes from the seeded works.
UPDATE subfield s SET works_count = (SELECT COUNT(*) FROM work w WHERE w.primary_subfield_id = s.id);
UPDATE field f   SET works_count = (SELECT COUNT(*) FROM work w WHERE w.primary_field_id = f.id);
UPDATE domain d  SET works_count = (SELECT COUNT(*) FROM work w WHERE w.primary_domain_id = d.id);
UPDATE topic t   SET works_count = (SELECT COUNT(*) FROM work_topic wt WHERE wt.topic_id = t.id);
