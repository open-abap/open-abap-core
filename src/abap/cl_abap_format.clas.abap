CLASS cl_abap_format DEFINITION PUBLIC.
  PUBLIC SECTION.
    CONSTANTS exp_preserve                    TYPE i VALUE cl_abap_math=>max_int4.

    CONSTANTS a_left                          TYPE i VALUE 1.
    CONSTANTS a_right                         TYPE i VALUE 2.
    CONSTANTS a_center                        TYPE i VALUE 3.

    CONSTANTS s_left                          TYPE i VALUE 1.
    CONSTANTS s_leftplus                      TYPE i VALUE 2.
    CONSTANTS s_leftspace                     TYPE i VALUE 3.
    CONSTANTS s_right                         TYPE i VALUE 4.
    CONSTANTS s_rightplus                     TYPE i VALUE 5.
    CONSTANTS s_rightspace                    TYPE i VALUE 6.

    CONSTANTS z_yes                           TYPE i VALUE 0.
    CONSTANTS z_no                            TYPE i VALUE 1.

    CONSTANTS n_raw                           TYPE i VALUE 0.
    CONSTANTS n_user                          TYPE i VALUE 1.
    CONSTANTS n_environment                   TYPE i VALUE 2.

    CONSTANTS d_raw                           TYPE i VALUE 0.
    CONSTANTS d_user                          TYPE i VALUE 1.
    CONSTANTS d_environment                   TYPE i VALUE 3.
    CONSTANTS d_iso                           TYPE i VALUE 2.

    CONSTANTS t_raw                           TYPE i VALUE 0.
    CONSTANTS t_user                          TYPE i VALUE 2.
    CONSTANTS t_environment                   TYPE i VALUE 3.
    CONSTANTS t_iso                           TYPE i VALUE 1.

    CONSTANTS ts_raw                          TYPE i VALUE 0.
    CONSTANTS ts_space                        TYPE i VALUE 1.
    CONSTANTS ts_user                         TYPE i VALUE 2.
    CONSTANTS ts_environment                  TYPE i VALUE 4.
    CONSTANTS ts_iso                          TYPE i VALUE 3.

    CONSTANTS c_raw                           TYPE i VALUE 0.
    CONSTANTS c_upper                         TYPE i VALUE 1.
    CONSTANTS c_lower                         TYPE i VALUE 2.

    CONSTANTS e_xml_text                      TYPE i VALUE 0.
    CONSTANTS e_xml_attr                      TYPE i VALUE 1.
    CONSTANTS e_xml_attr_dq                   TYPE i VALUE 2.
    CONSTANTS e_xml_attr_sq                   TYPE i VALUE 3.
    CONSTANTS e_html_text                     TYPE i VALUE 4.
    CONSTANTS e_html_attr                     TYPE i VALUE 5.
    CONSTANTS e_html_attr_dq                  TYPE i VALUE 6.
    CONSTANTS e_html_attr_sq                  TYPE i VALUE 7.
    CONSTANTS e_html_js                       TYPE i VALUE 8.
    CONSTANTS e_html_js_html                  TYPE i VALUE 10.
    CONSTANTS e_url                           TYPE i VALUE 12.
    CONSTANTS e_url_full                      TYPE i VALUE 14.
    CONSTANTS e_uri                           TYPE i VALUE 16.
    CONSTANTS e_uri_full                      TYPE i VALUE 18.
    CONSTANTS e_regex                         TYPE i VALUE 20.
    CONSTANTS e_string_tpl                    TYPE i VALUE 22.
    CONSTANTS e_json_string                   TYPE i VALUE 24.
    CONSTANTS e_xss_ml                        TYPE i VALUE 26.
    CONSTANTS e_xss_ml_nu                     TYPE i VALUE 27.
    CONSTANTS e_xss_js                        TYPE i VALUE 28.
    CONSTANTS e_xss_js_nu                     TYPE i VALUE 29.
    CONSTANTS e_xss_css                       TYPE i VALUE 30.
    CONSTANTS e_xss_css_nu                    TYPE i VALUE 31.
    CONSTANTS e_xss_url                       TYPE i VALUE 32.
ENDCLASS.

CLASS cl_abap_format IMPLEMENTATION.

ENDCLASS.
