# Applet

module AppletHelper

  def applet_tag( options )
    jars = options[:jars] || [options[:jar]]
    jar_uri = jars.map{ |jar_name| "/jars/#{jar_name}.jar" }.join(",")
    code = options[:main_class].gsub(/\./, '/') + '.class'
    params = options[:params] || {}
    java_url = "http://www.java.com/en/download/"
    missing_text = options[:missing_text] ||
        "This page requires Java. Please download and install Java from <a href=\"#{java_url}\" target=\"_blank\">#{java_url}</a>"
    params_code = params.map do |k, v|
      "<param name='#{k}' value='#{v}' />"
    end.join("\n")

    code =
"""
<!--[if !IE]> -->
<object classid='java:#{code}'
              type='application/x-java-applet'
              archive='#{jar_uri}'
              height='#{options[:height]}' width='#{options[:width]}' >
  <param name='code' value='#{code}' />
  <!-- For Konqueror -->
  <param name='archive' value='#{jar_uri}' />
  <param name='persistState' value='false' />
  #{params_code}
  <center>
    <p><strong>#{missing_text}</strong></p>
  </center>
</object>
<!--<![endif]-->
<!--[if IE]>
<object classid='clsid:8AD9C840-044E-11D1-B3E9-00805F499D93'
        codebase='http://java.sun.com/update/1.6.0/jinstall-6u13-windows-i586.cab'
        height='#{options[:height]}' width='#{options[:width]}' >
  <param name='code' value='#{code}' />
  <param name='archive' value='#{jar_uri}' />
  <param name='persistState' value='false' />
  #{params_code}
  <center>
    <p><strong>#{missing_text}</strong></p>
  </center>
</object>
<![endif]-->
"""
    if Rails::VERSION::MAJOR < 3
      code
    else
      raw(code)
    end
  end

end

ActionView::Base.send :include, AppletHelper
