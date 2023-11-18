Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from relay-b03.edpnet.be (relay-b03.edpnet.be [212.71.1.220])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEFADD4D
	for <linux-bcachefs@vger.kernel.org>; Sat, 18 Nov 2023 11:45:30 -0800 (PST)
X-ASG-Debug-ID: 1700336721-24639c7fb84da54000b-qsCQDO
Received: from linuxserver.costadelsollie.local (213.219.166.214.adsl.dyn.edpnet.net [213.219.166.214]) by relay-b03.edpnet.be with ESMTP id FifaMCrBQ8rnSXOZ; Sat, 18 Nov 2023 20:45:25 +0100 (CET)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 213.219.166.214.adsl.dyn.edpnet.net[213.219.166.214]
X-Barracuda-Apparent-Source-IP: 213.219.166.214
From: Janpieter Sollie <janpieter.sollie@kabelmail.de>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org
Cc: Janpieter Sollie <janpieter.sollie@kabelmail.de>,
	jpsollie <janpieter.sollie@edpnet.be>
Subject: [PATCH v4 10/10] ktest: use overlays to store arch-specific bcachefs-tools build
Date: Sat, 18 Nov 2023 20:38:49 +0100
X-ASG-Orig-Subj: [PATCH v4 10/10] ktest: use overlays to store arch-specific bcachefs-tools build
Message-ID: <20231118194453.41324-11-janpieter.sollie@kabelmail.de>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231118194453.41324-1-janpieter.sollie@kabelmail.de>
References: <20231118194453.41324-1-janpieter.sollie@kabelmail.de>
Reply-To: Janpieter Sollie <janpieter.sollie@edpnet.be>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: 213.219.166.214.adsl.dyn.edpnet.net[213.219.166.214]
X-Barracuda-Start-Time: 1700336725
X-Barracuda-URL: https://212.71.1.220:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 3104
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.116931
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------

when running tests, eg test1 on arch 1, and then on arch 2,
the whole bcachefs-tools package needs to be rebuilt:
all binaries of arch 1 need to be erased, and recompiled for arch 2
when going back to arch 1, it happens again

This patch fixes the issue by applying a arch-specific overlay,
so bcachefs-tools doesn't need a full rebuild every time.
The overlay is mounted via fuse-overlay.
If this isn't available, it will fall back to rsync,
causing a larger waste of disk space,
and not-applied-immediately git commits.

Signed-of-by: jpsollie <janpieter.sollie@edpnet.be>
---
 lib/common.sh                        |  2 ++
 tests/bcachefs/bcachefs-test-libs.sh | 22 +++++++++++++++++++---
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/lib/common.sh b/lib/common.sh
index 6a9a912..14ead88 100644
--- a/lib/common.sh
+++ b/lib/common.sh
@@ -19,6 +19,8 @@ ktest_exit()
     fi
 
     [[ -n $ktest_tmp ]] && rm -rf "$ktest_tmp"
+    #umount overlayfs of bcachefs-tools if needed
+    [[ -n $ktest_tmp && $(grep bcachefs-tools-$ktest_arch /proc/mounts) ]] && umount $(grep bcachefs-tools-$ktest_arch /proc/mounts | cut -d' ' -f 2)
     true
 }
 
diff --git a/tests/bcachefs/bcachefs-test-libs.sh b/tests/bcachefs/bcachefs-test-libs.sh
index 90c36b6..f6461b5 100644
--- a/tests/bcachefs/bcachefs-test-libs.sh
+++ b/tests/bcachefs/bcachefs-test-libs.sh
@@ -7,16 +7,32 @@
 . $(dirname $(readlink -e "${BASH_SOURCE[0]}"))/../test-libs.sh
 bch_loc=$(dirname $(readlink -e "${BASH_SOURCE[0]}"))/bcachefs-tools
 
-require-git http://evilpiepirate.org/git/bcachefs-tools.git
-if [[ ! -f "${bch_loc}/.last_arch_for_compile" || "$(cat ${bch_loc}/.last_arch_for_compile)" != $ktest_arch ]]; then
+declare -A ov_dirs=(["tmp"]="${bch_loc}/../.tmp-bcachefs-tools-overlay" \
+              ["diff"]="${bch_loc}/../.bcachefs-tools-overlay-${ktest_arch}" \
+              ["merge"]="${bch_loc}/../bcachefs-tools-${ktest_arch}")
+
+for dir_overlay in ${ov_dirs[@]}; do
+  if [[ ! -d ${dir_overlay} ]]; then mkdir -p ${dir_overlay}; fi
+done
+
+if [[ $(which fuse-overlayfs) && ! $(grep bcachefs-tools-$ktest_arch /proc/mounts) ]]; then
+	fuse-overlayfs -o lowerdir=${bch_loc},upperdir=${ov_dirs["diff"]},workdir=${ov_dirs["tmp"]} ${ov_dirs["merge"]}
+elif [[ ! $(grep bcachefs-tools-$ktest_arch /proc/mounts) ]]; then
+	rsync -av ${bch_loc}/ ${ov_dirs["merge"]}/
+fi
+
+bch_loc=$(dirname $(readlink -e "${BASH_SOURCE[0]}"))/bcachefs-tools-${ktest_arch}
+
+if [[ ! -f "${bch_loc}/.last_arch_for_compile" || "$(cat ${bch_loc}/.last_arch_for_compile)" != ${ktest_arch} ]]; then
 	make -C ${bch_loc} clean >/dev/null 2>&1;
 	rm -rf "${bch_loc}/rust-src/target/*";
 	find ${bch_loc} -name "*.o" -exec rm {} \;
 	find ${bch_loc} -name "*.a" -exec rm {} \;
 	echo $ktest_arch > ${bch_loc}/.last_arch_for_compile
 fi
-require-make bcachefs-tools
 
+require-git http://evilpiepirate.org/git/bcachefs-tools.git
+require-make bcachefs-tools-${ktest_arch}
 require-kernel-config BCACHEFS_FS
 
 if [[ ! -v NO_BCACHEFS_DEBUG ]]; then
-- 
2.42.1

