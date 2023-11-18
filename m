Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from relay-b03.edpnet.be (relay-b03.edpnet.be [212.71.1.220])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C63194
	for <linux-bcachefs@vger.kernel.org>; Sat, 18 Nov 2023 11:45:26 -0800 (PST)
X-ASG-Debug-ID: 1700336721-24639c7fb84da540001-qsCQDO
Received: from linuxserver.costadelsollie.local (213.219.166.214.adsl.dyn.edpnet.net [213.219.166.214]) by relay-b03.edpnet.be with ESMTP id 7jihd3I1r93PBcXo; Sat, 18 Nov 2023 20:45:21 +0100 (CET)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 213.219.166.214.adsl.dyn.edpnet.net[213.219.166.214]
X-Barracuda-Apparent-Source-IP: 213.219.166.214
From: Janpieter Sollie <janpieter.sollie@kabelmail.de>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: KTEST: make cross-arch testing available for big and little endian
Date: Sat, 18 Nov 2023 20:38:39 +0100
X-ASG-Orig-Subj: KTEST: make cross-arch testing available for big and little endian
Message-ID: <20231118194453.41324-1-janpieter.sollie@kabelmail.de>
X-Mailer: git-send-email 2.42.1
Reply-To: Janpieter Sollie <janpieter.sollie@edpnet.be>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: 213.219.166.214.adsl.dyn.edpnet.net[213.219.166.214]
X-Barracuda-Start-Time: 1700336721
X-Barracuda-URL: https://212.71.1.220:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 400
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.116931
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------

Hereby the (I hope final) revision of my work around ktest cross-arch functionality
Changes since v3:

-  bcachefs-tools specific code has been eliminated from testrunner
-  cross-compile on host for target has been abandoned, 
   and replaced with overlays (for now) until a better solution comes up
-  various cleanups as suggested

Happy testing!

Kind regards,

Janpieter Sollie


