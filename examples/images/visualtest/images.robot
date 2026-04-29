*** Settings ***
Documentation       This suite shows...
# DocTest.VisualTest library is used to perform image comparisons.
Library             DocTest.VisualTest   
...    embed_screenshots=True
...    run_keyword_on_warn_threshold=Log \ Foo


*** Test Cases ***

Same Image
    [Documentation]    Verify that the hero section contains an image of a motorcycle.
    Compare Images   
    ...    reference_image=${CURDIR}/img/map_orig.png  
    ...    candidate_image=${CURDIR}/img/map_orig.png  

Image with 1 Diff
    Compare Images   
    ...    reference_image=${CURDIR}/img/map_orig.png  
    ...    candidate_image=${CURDIR}/img/map_1_diff.png  

Image with 2 Diff
    Compare Images   
    ...    reference_image=${CURDIR}/img/map_orig.png  
    ...    candidate_image=${CURDIR}/img/map_2_diff.png  

Image with 3 Diff
    Compare Images   
    ...    reference_image=${CURDIR}/img/map_orig.png  
    ...    candidate_image=${CURDIR}/img/map_3_diff.png  

Image with 29% Diff
    Compare Images   
    ...    reference_image=${CURDIR}/img/map_orig.png  
    ...    candidate_image=${CURDIR}/img/map_29pct_diff.png  
    ...    threshold=0.25

Image with 0.0055% Diff
    Compare Images   
    ...    reference_image=${CURDIR}/img/map_orig.png  
    ...    candidate_image=${CURDIR}/img/map_1_diff.png  
    ...    threshold_warn=0.000001  # 0.02%
    ...    threshold=0.0006  # 0.06%

Image with 0.087% Diff
    Compare Images   
    ...    reference_image=${CURDIR}/img/map_orig.png  
    ...    candidate_image=${CURDIR}/img/map_2_diff.png  
    ...    threshold=0.0010  # 0.1%

Image with 0.18% Diff
    Compare Images   
    ...    reference_image=${CURDIR}/img/map_orig.png  
    ...    candidate_image=${CURDIR}/img/map_3_diff.png  
    ...    threshold=0.0020  # 0.2%

    #...    template=${template}  take_screenshots=True  threshold=0.2  log_template=True
    
