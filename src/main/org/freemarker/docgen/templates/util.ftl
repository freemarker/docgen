<#ftl ns_prefixes={"D":"http://docbook.org/ns/docbook"}>

<#function getOptionalTitleAsString node>
  <#return titleToString(getOptionalTitleElement(node))>
</#function>

<#function getOptionalTitleElement node>
  <#var result = node.title>
  <#if !result?has_content><#set result = node.info.title></#if>
  <#if !result?has_content>
     <#return null>
  </#if>
  <#return result>
</#function>

<#function getRequiredTitleElement node>
  <#var result = getOptionalTitleElement(node)>
  <#if !result??>
    <#stop "Required \"title\" child element missing for element \""
        + node?node_name + "\".">
  </#if>
  <#return result>
</#function>

<#function getRequiredTitleAsString node>
  <#return titleToString(getRequiredTitleElement(node))>
</#function>

<#function getOptionalSubtitleElement node>
  <#var result = node.subtitle>
  <#if !result?has_content><#set result = node.info.subtitle></#if>
  <#if !result?has_content>
    <#return null>
  </#if>
  <#return result>
</#function>

<#function getOptionalSubtitleAsString node>
  <#return titleToString(getOptionalSubtitleElement(node))>
</#function>

<#function titleToString titleNode>
  <#if titleNode?is_null>
    <#-- Used for optional title -->
    <#return null>
  </#if>
  <#if !titleNode?is_node>
    <#-- Just a string... -->
    <#return titleNode>
  </#if>
  
  <#var res = "">
  <#list titleNode?children as child>
    <#if child?node_type == "text">
      <#set res = res + child>
    <#elseif child?node_type == "element">
      <#var name = child?node_name>
      <#if name == "literal"
          || name == "classname" || name == "methodname" || name == "package"
          || name == "replaceable"
          || name == "emphasis"
          || name == "phrase">
        <#set res = res + titleToString(child)>
      <#elseif node != "subtitle">
        <#stop 'The "${name}" in titles is not supported by Docgen.'>
      </#if>
    </#if>
  </#list>
  
  <#return res>
</#function>

<#-- "docStructElem" is a part, chapter, section, etc., NOT a title element -->
<#function getTitlePrefix docStructElem, extraSpacing=false, longForm=false>
  <#var prefix = docStructElem.@docgen_title_prefix[0]!null>
  <#if !prefix??>
    <#return "">
  </#if>

  <#var type = docStructElem?node_name>
  
  <#var spacer>
  <#if extraSpacing>
    <#set spacer = "\xA0\xA0\xA0">
  <#else>
    <#set spacer = " ">
  </#if>
  
  <#if type = "chapter">
    <#return longForm?string("Chapter ", "") + prefix + spacer>
  <#elseif type = "appendix">
    <#return longForm?string("Appendix ", "") + prefix + spacer>
  <#elseif type = "part">
    <#return longForm?string("Part ", "") + prefix + spacer>
  <#elseif type = "article">
    <#return longForm?string("Article ", "") + prefix + spacer>
  <#else>
    <#return prefix + spacer>
  </#if>
</#function>

<#macro invisible1x1Img>
  <img src="docgen-resources/img/none.gif" width="1" height="1" alt="" hspace="0" vspace="0" border="0"/><#t>
</#macro>