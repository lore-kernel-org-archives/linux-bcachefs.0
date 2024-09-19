Received: from out162-62-58-216.mail.qq.com (out162-62-58-216.mail.qq.com [162.62.58.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917B32746C;
	Thu, 19 Sep 2024 15:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726759079; cv=none; b=qp+p1DR2Gb3QD1t4fjRuocLTrBXjXRlzNAQcN8k2st42GL209NzOA/LLYKumrTobXLDf3xrdAk6GRXZJul0en+oeOVnQCMKkW+GmCAaMHMs5bwCSC/WCqwF9G1vo5bYu7Di/lGyf85nrkCCftLOCKi8W++fVjNTjyrixa0b/EwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726759079; c=relaxed/simple;
	bh=8e1qIlw1/RHOl6SNU+FwAk2nDYlxZ0kqjgZGoDnkwzc=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=eC7snhJb3H05r02R4XI2DaawP+1dSUIkLfOVZc2ViOAtu46zVVC3SygTcfe07iBkSpuuvJlWm2FnqWwf/unj7FlVs+PLCH2sf3AVTewXGeA+THw/h/B+fbBxbiW7KaTW3blNyUQg1wYnUZFaUdKqkINEo7AVzETGUutxEpXYQcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=j9PPwqGP; arc=none smtp.client-ip=162.62.58.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="j9PPwqGP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1726759072; bh=adl1pm0YMKYb3oWFKe+zH9DtTttrIh+DhbVpZnCd3gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j9PPwqGPmx2qKcxqaIF1MM01IO5MoetIcfWH4Yt9h6AipGrueppHPqnv5BWaFNXOF
	 VOvuhJw3waoggah5hzBUd04IBzScS9o2ncxpq3GymHezpq2A2L7+/adBzKYFEhp52I
	 rVjGCaX/oC3S1tFEgg/fY6sYIIZlXSkswLQw5n24=
Received: from pek-lxu-l1.wrs.com ([111.198.224.50])
	by newxmesmtplogicsvrszc19-0.qq.com (NewEsmtp) with SMTP
	id 2E7BCE88; Thu, 19 Sep 2024 23:11:39 +0800
X-QQ-mid: xmsmtpt1726758699t9305bfku
Message-ID: <tencent_50B5A5988DAD922A5D9B5DC9190C4FB08D07@qq.com>
X-QQ-XMAILINFO: No84gL0ijbqcYLvTBmcx4cSABjAsh9xinR+FSEen+LmVMm6jaTeFEz7Vdo/xCo
	 gFsqYrEFNuv1bd8zFecFd9mbuWQ1hTVq1CU6YAtciKCDNgGRTMwCTgz5U4Q/etuRAvCPsMjDnqWA
	 8mQr37JoPdLwgSw8fhv0lE2ef0zuU0MlMfoUA2w/vkLpvi0cbNuyMUrTvtFfGsve+bmEbchBXXql
	 q0zRtHpFASuatmak45N0hUm/mt0NC33q5M8a/P6+vr/+x1s7Cdzzn57NcN2+A0EHsCk7LwnfuD4u
	 iuhlYTzhi+TFOowa0citGxAbCo+IbQdxiWpSLk/1W4CeDGUUaxgKKgGpdy8Bg+aeYzvvoVqm3Pnc
	 kg9MTSt3ddXRUcdXGLTk1BYcYu1Xo0jbiLlR7+yupOiFgSyEFfDRGOnCwuD635qHDH2MlYjvJNN7
	 ApvXy/mAnchBpqUr5bAz3fTdPze97KRCiDri6+t7LS3d/6WZgICztA5yvEUDSKCFICAaT4j1TIU/
	 AcwRezcv1ge+cwT6V0QSuUnlu6Pqmzd27TScQZGKKzuCs+d6gb5emgzydG6/OLeazLAzVRptYZC/
	 roe1gh4Xzf3my4h9thtRGAQ3VSmsMZga1TjpsL3lsUrVBvE74WZfw4rPHQMiNFXzg3uyzrv8ePB9
	 chtew2JgppJjfBii0WrMfnM5/o/+4NgRSUOHhmzlleh/iAWGXgWHYYo3XMUt1ejCFfrrLYHBgpv6
	 xeeRPAnWy7vNxK9I67J85ZD1zxyX+e6lAq5cQu9yM6EcnpsnJck0WNjFIKZgmtaR6hP+qduFtMhO
	 ld0SFgtjFFkiPysPgBM2aaK7UADVTgmEIRP6GdDDFgc+l0Dt3KEiDZ3YDLff2SlF8a4tflaQpnJt
	 qAuIlP5nzjanau66DW51qCl2HuNbcWpoF+wKBPbUhjcYN/2vf/d3Q=
X-QQ-XMRINFO: OD9hHCdaPRBwq3WW+NvGbIU=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+294f528e56138c357a48@syzkaller.appspotmail.com
Cc: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] BUG: unable to handle kernel paging request in bch2_opt_to_text
Date: Thu, 19 Sep 2024 23:11:40 +0800
X-OQ-MSGID: <20240919151139.151892-2-eadavis@qq.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <66eb6254.050a0220.92ef1.0009.GAE@google.com>
References: <66eb6254.050a0220.92ef1.0009.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The format of the 'name=value' key value pair included in the options is
incorrect, if only name is present.

#syz test

diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index e10fc1da71b1..5616dc8570fa 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -472,6 +472,12 @@ int bch2_parse_one_mount_opt(struct bch_fs *c, struct bch_opts *opts,
 	u64 v;
 	int ret, id;
 
+	if (!val) {
+		pr_err("Bad mount option, value is NULL");
+		ret = -BCH_ERR_option_value;
+		goto out;
+	}
+
 	id = bch2_mount_opt_lookup(name);
 
 	/* Check for the form "noopt", negation of a boolean opt: */

