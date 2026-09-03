/*
 * HybridWebProperty
 * Property manager for the Web component.
 */

import { BaseProperty } from './HybridBaseProperty';
import { HybridWebView } from './HybridWebView';
import { hilog } from '@kit.PerformanceAnalysisKit';

export class HybridWebProperty extends BaseProperty<HybridWebView> {
  // Attribute constants
  static readonly ATTRIBUTE_SOURCE = 'source';
  // The A2UI v0.9 basic_catalog.json schema for "Web" names this property
  // "url" (its only property besides the shared id/styles/component common
  // to every component) -- confirmed against the schema and against what the
  // native bridge actually delivers here (HybridViewTag logs
  // "attribute[key:url,value:...]"). ATTRIBUTE_SOURCE alone silently dropped
  // every real "url" attribute: handleAttribute()'s switch fell through to
  // its default case, loadWebSource() was never called, and the Web view sat
  // at its class-field defaults (empty source, isUrl=false) -- which is
  // exactly the "loads about:blank, then loads empty data" no-op the
  // HTML-mode branch takes for a never-set source. Every Web-rendered URL
  // (e.g. a YouTube embed from genui.web()) rendered as a blank box.
  static readonly ATTRIBUTE_URL = 'url';
  static readonly ATTRIBUTE_WEB_HEIGHT = 'height';
  static readonly ATTRIBUTE_MIN_HEIGHT = 'min-height';
  static readonly ATTRIBUTE_MAX_HEIGHT = 'max-height';

  // Event constants
  static readonly EVENT_LOAD_FINISH = 'loadfinish';
  static readonly EVENT_LOAD_ERROR = 'loaderror';
  static readonly EVENT_PAGE_START = 'pagestart';

  // Attribute fields
  source: string = '';
  height: number = 0;
  minHeight: number = 0;
  maxHeight: number = 0;

  constructor(view: HybridWebView) {
    super(view);
  }

  updateAttribute(attrMap: Map<string, string>): void {
    attrMap.forEach((value: string, key: string) => {
      this.handleAttribute(key, value);
    });
  }

  private handleAttribute(key: string, value: string): void {
    switch (key) {
      case HybridWebProperty.ATTRIBUTE_SOURCE:
      case HybridWebProperty.ATTRIBUTE_URL:
        this.handleNormal_source(value);
        break;
      case HybridWebProperty.ATTRIBUTE_WEB_HEIGHT:
        this.handleNormal_height(value);
        break;
      case HybridWebProperty.ATTRIBUTE_MIN_HEIGHT:
        this.handleNormal_minHeight(value);
        break;
      case HybridWebProperty.ATTRIBUTE_MAX_HEIGHT:
        this.handleNormal_maxHeight(value);
        break;
      case HybridWebProperty.EVENT_LOAD_FINISH:
        this.handleEvent_loadfinish(value);
        break;
      case HybridWebProperty.EVENT_LOAD_ERROR:
        this.handleEvent_loaderror(value);
        break;
      case HybridWebProperty.EVENT_PAGE_START:
        this.handleEvent_pagestart(value);
        break;
      default:
        break;
    }
  }

  handleNormal_source(source: string): void {
    this.source = source;
    (this.myView as HybridWebView).loadWebSource(source);
  }

  handleNormal_height(height: string): void {
    try {
      this.height = parseFloat(height);
      (this.myView as HybridWebView).updateStyles();
    } catch (e) {
      hilog.error(0, 'HybridWeb', 'handleNormal_height error: %{public}s', e.message);
    }
  }

  handleNormal_minHeight(minHeight: string): void {
    try {
      this.minHeight = parseFloat(minHeight);
      (this.myView as HybridWebView).updateStyles();
    } catch (e) {
      hilog.error(0, 'HybridWeb', 'handleNormal_minHeight error: %{public}s', e.message);
    }
  }

  handleNormal_maxHeight(maxHeight: string): void {
    try {
      this.maxHeight = parseFloat(maxHeight);
      (this.myView as HybridWebView).updateStyles();
    } catch (e) {
      hilog.error(0, 'HybridWeb', 'handleNormal_maxHeight error: %{public}s', e.message);
    }
  }

  handleEvent_loadfinish(value: string): void {
    hilog.debug(0, 'HybridWeb', 'handleEvent_loadfinish: %{public}s', value);
  }

  handleEvent_loaderror(value: string): void {
    hilog.error(0, 'HybridWeb', 'handleEvent_loaderror: %{public}s', value);
  }

  handleEvent_pagestart(value: string): void {
    hilog.debug(0, 'HybridWeb', 'handleEvent_pagestart: %{public}s', value);
  }
}
