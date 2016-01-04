public with sharing class LitmosSSO {

	public static String getLitmosApiKey() {	
		return LitmosSSOSettings__c.getOrgDefaults().APIKey__c;
	}

	public static String getLitmosApiUrl() {	
		return LitmosSSOSettings__c.getOrgDefaults().APIURL__c;
	}

        /*
        User u = new User(
                Username = 'lindsey.thomas@redargyle.com',
                FirstName = 'thomas',
                LastName = 'jefferson',
                Email = 'lindsey.thomas@redargyle.com'
        );
        HttpResponse httpResponse = LitmosSSO.provisionUser(u);

        RESULT
        <User xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
                <Id>bh8UPenOgts1</Id>
                <UserName>test2@test2.com</UserName>
                <FirstName>test2</FirstName>
                <LastName>test2</LastName>
                <FullName>test2 test2</FullName>
                <Email>test2@test2.com</Email>
                <AccessLevel>Learner</AccessLevel>
                <DisableMessages>true</DisableMessages>
                <Active>true</Active>
                <Skype/>
                <PhoneWork/>
                <PhoneMobile/>
                <LastLogin/>
                <LoginKey>https://continuitypartnerportal.litmos.com//login.aspx?loginkey=1bcaab61-52df-4f4e-b5af-903d47dd95f9</LoginKey>
                <IsCustomUsername>false</IsCustomUsername>
                <Password/>
                <SkipFirstLogin>false</SkipFirstLogin>
                <TimeZone>Pacific Standard Time</TimeZone>
                <SalesforceId i:nil="true"/>
                <OriginalId>2963517</OriginalId>
                <Street1/>
                <Street2/>
                <City/>
                <State/>
                <PostalCode/>
                <Country/>
                <CompanyName/>
                <JobTitle/>
                <CustomField1/>
                <CustomField2/>
                <CustomField3/>
                <Culture>en-US</Culture>
                <CustomField4/>
                <CustomField5/>
                <CustomField6/>
                <CustomField7/>
                <CustomField8/>
                <CustomField9/>
                <CustomField10/>
                <SalesforceContactId i:nil="true"/>
                <SalesforceAccountId i:nil="true"/>
                <CreatedDate>2015-11-19T09:08:04Z</CreatedDate>
                <Points>0</Points>
        </User>

        */

        public static HttpResponse provisionUser(User u) {

                String requestBody = '<User>';
                requestBody += '<Id></Id>';
                requestBody += '<UserName>' + u.Username + '</UserName>';
                requestBody += '<FirstName>' + u.FirstName + '</FirstName>';
                requestBody += '<LastName>' + u.LastName + '</LastName>';
                requestBody += '<FullName></FullName>';
                requestBody += '<Email>' + u.Email + '</Email>';
                requestBody += '<AccessLevel>Learner</AccessLevel>';
                requestBody += '<DisableMessages>true</DisableMessages>';
                requestBody += '<Active>true</Active>';
                requestBody += '<LastLogin></LastLogin>'; 
                requestBody += '<LoginKey></LoginKey>';
                requestBody += '<IsCustomUsername>false</IsCustomUsername>';
                requestBody += '<SkipFirstLogin>true</SkipFirstLogin>';
                requestBody += '<TimeZone></TimeZone>';
                requestBody += '</User>';

                try {
                        HttpRequest httpRequest = new HttpRequest();
                        // POST https://api.litmos.com/v1.svc/users?apikey=API_KEY&source=axcient&search=USERNAME
                        httpRequest.setEndpoint(getLitmosApiUrl() + '/users?apikey=' + getLitmosApiKey() + '&source=axcient');
                        httpRequest.setMethod('POST');
                        httpRequest.setHeader('Content-Type', 'text/xml');
                        httpRequest.setBody(requestBody);
                        Http http = new Http();
                        HttpResponse httpResponse = http.send(httpRequest);
                        system.debug(httpResponse);
                        system.debug(httpResponse.getBody());
                        return httpResponse;
                }
                catch(Exception ex) {
                        return null;
                }

        }

	// returns the Litmos User Id based on a searchTerm
	// search term is typically Salesforce username or email address
	// note possible need to attempt with "ax-" prefix on username
        public static String getLitmosUserId(List<String> searchTerms) {
		
                for(String searchTerm : searchTerms) {

                        try {

                		// make httprequest
                		HttpRequest httpRequest = new HttpRequest();
                		// https://api.litmos.com/v1.svc/users?apikey=API_KEY&source=axcient&search=USERNAME
                                httpRequest.setEndpoint(getLitmosApiUrl() + '/users?apikey=' + getLitmosApiKey() + '&source=axcient&search=' + searchTerm);
                                httpRequest.setMethod('GET');
                                Http http = new Http();
                                HttpResponse httpResponse = http.send(httpRequest);
                                system.debug(httpResponse);
                                
                                if(httpResponse.getStatusCode() != 200) continue;

                                Dom.Document xml = httpResponse.getBodyDocument();
                                Dom.XMLNode users = xml.getRootElement();
                                
                                if(users.getChildElements().isEmpty()) {
                                        // blank result example = <Users xmlns:i="http://www.w3.org/2001/XMLSchema-instance"/>
                                        // no results, continue
                                        continue;
                                }        

                                // found results, return it
                                return users.getChildElements()[0].getChildElement('Id', null).getText();

                        }
                        catch(Exception ex) {
                                continue;
                        }

                }

                return null;

        }

	// returns the Litmos LoginKey (specific URL)
	public static String getLitmosSSOUrl(String litmosUserId) {

                try {
                        HttpRequest httpRequest = new HttpRequest();
                        // https://api.litmos.com/v1.svc/users?apikey=API_KEY&source=axcient&search=USERNAME
                        httpRequest.setEndpoint(getLitmosApiUrl() + '/users/' + litmosUserId + '?apikey=' + getLitmosApiKey() + '&source=axcient');
                        httpRequest.setMethod('GET');
                        Http http = new Http();
                        HttpResponse httpResponse = http.send(httpRequest);
                        system.debug(httpResponse);

                        if(httpResponse.getStatusCode() != 200) return null;

                        Dom.Document xml = httpResponse.getBodyDocument();
                        Dom.XMLNode user = xml.getRootElement();
                        return user.getChildElement('LoginKey', null).getText();
                        
                }
                catch(Exception ex) {
                        return null;
                }
		
	} 

        /*
        String url = LitmosSSO.getLitmosSSOUrl(new String[] { 'tom@redargyle.com' });
        system.debug(url);
        */
        public static String getLitmosSSOUrl(List<String> searchTerms) {
                String litmosUserId = getLitmosUserId(searchTerms);
                if(litmosUserId == null) return null;
                return getLitmosSSOUrl(litmosUserId);
        }

}