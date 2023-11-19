Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from relay-b02.edpnet.be (relay-b02.edpnet.be [212.71.1.222])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392B611A
	for <linux-bcachefs@vger.kernel.org>; Sun, 19 Nov 2023 08:02:09 -0800 (PST)
X-ASG-Debug-ID: 1700409726-214fdf696263e1b0001-qsCQDO
Received: from linuxserver.costadelsollie.local (213.219.166.214.adsl.dyn.edpnet.net [213.219.166.214]) by relay-b02.edpnet.be with ESMTP id pPt7dXNW1ENGNiVt; Sun, 19 Nov 2023 17:02:06 +0100 (CET)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 213.219.166.214.adsl.dyn.edpnet.net[213.219.166.214]
X-Barracuda-Apparent-Source-IP: 213.219.166.214
From: Janpieter Sollie <janpieter.sollie@kabelmail.de>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: KTEST cross-arch support
Date: Sun, 19 Nov 2023 16:48:07 +0100
X-ASG-Orig-Subj: KTEST cross-arch support
Message-ID: <20231119160155.34496-1-janpieter.sollie@kabelmail.de>
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
X-Barracuda-Start-Time: 1700409726
X-Barracuda-URL: https://212.71.1.222:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 1068
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.116969
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------

Hello everybody

After feedback, a new reconsideration.

Changes since v4:

- a lot more variables have been cleaned up
- root_image create can fallback to debian sid if it can't find the requested architecture using specified mirror
- all sid distros use the extended pkg installer to fix dependency issues
- we do not assign 8G of ram if nr_cpus is < 8

Tested working on gentoo linux on a x86_64-pc-linux-gnu setup using qemu 8.1.2:

root_image create -a:
- amd64
- armhf
- aarch64
- ppc64
- riscv64
- s390x
- sparc64

build-test-kernel boot -v -P -a:
- amd64
- armhf
- aarch64
- ppc64
- riscv64
- s390x

Not tested:
i686, I doubt any bugs will come up when armhf & amd64 are already OK

Tested Broken:
build-test-kernel boot -a sparc64,
it compiles the kernel, but doesn't boot.
A lot of hacks have to be applied to make qemu bring it up,
and these may decrease other arches' stability
if anybody is interested to cooperate, and dig into it, be my guest,
but I'll need some time to make sparc64 work

Janpieter Sollie


