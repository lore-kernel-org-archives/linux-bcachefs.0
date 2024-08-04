Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E403A17588;
	Sun,  4 Aug 2024 09:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722763227; cv=none; b=EPkI9tR0hEeB5yvH/bVOn2fgcu/xc4RWw8pF4wJ4OMUfvTF5pUp67FQXQKe041kmkqUvxpx4pbgzBQ1foQdPQpDH2rQJwg/3aQNsPpEDX6IWXGLqRCGOSWbappjWST7Tm08kq46Ro+8SnumNsHyVwOzhZ+eFOCBxv53VV4ujkp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722763227; c=relaxed/simple;
	bh=ayQagBeZalevYPtQBI9YWjYEybeAhnI5SoE7BwzoLRU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=d5nhn8baHXTULEr2VRGPfoHSGdcOdSwsnJHXga6b6Al3kMua5glLMZrLzqE6Isg3AoXjMEZV98msImTz52wr0+nPqFbTcR0s5lWYC14bz1enzciARKxK6olwSr2ZaAKhDJlNBWvx/XmTta9WBQPVXgEZIGHXxDyYFjIWaxACjsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: c312c516524211efa216b1d71e6e1362-20240804
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN
	HR_FROM_NAME, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	DN_TRUSTED, SRC_TRUSTED, SA_UNTRUSTED, SA_UNFAMILIAR, SN_UNTRUSTED
	SN_UNFAMILIAR, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD
	CIE_GOOD_SPF, CIE_UNKNOWN, GTI_FG_BS, GTI_C_CI, GTI_FG_IT
	GTI_RG_INFO, GTI_C_BU, AMN_T1, AMN_GOOD, AMN_C_TI
	AMN_C_BU, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:a3ab75a1-ac9f-465e-a91f-627088f0200b,IP:10,
	URL:0,TC:0,Content:-5,EDM:25,RT:0,SF:5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:35
X-CID-INFO: VERSION:1.1.38,REQID:a3ab75a1-ac9f-465e-a91f-627088f0200b,IP:10,UR
	L:0,TC:0,Content:-5,EDM:25,RT:0,SF:5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:35
X-CID-META: VersionHash:82c5f88,CLOUDID:70af7d21835f03586e3743aae2453d02,BulkI
	D:240804171638GUAHFMRT,BulkQuantity:1,Recheck:0,SF:72|19|43|74|66|23|200|1
	02,TC:nil,Content:0,EDM:5,IP:-2,URL:1,File:nil,RT:nil,Bulk:40,QS:nil,BEC:n
	il,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FSD,TF_CID_SPAM_ULS
X-UUID: c312c516524211efa216b1d71e6e1362-20240804
X-User: zhanghao1@kylinos.cn
Received: from pve.sebastian [(118.250.1.66)] by mailgw.kylinos.cn
	(envelope-from <zhanghao1@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1697066970; Sun, 04 Aug 2024 17:20:16 +0800
From: zhanghao <zhanghao1@kylinos.cn>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+1a11884d9c9f1353942d@syzkaller.appspotmail.com,
	zhanghao <zhanghao1@kylinos.cn>
Subject: [PATCH] bcachefs: Add check for the size of combined key and value
Date: Sun,  4 Aug 2024 17:20:03 +0800
Message-Id: <20240804092003.142093-1-zhanghao1@kylinos.cn>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The bkey_val_bytes() gets the number of bytes of value
stored in bkey->u64s.If u64s is smaller than BKEY_U64s,
it causes a negative number to be converted to an
unsigned number.

Reported-by: syzbot+1a11884d9c9f1353942d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1a11884d9c9f1353942d
Fixes: ba81523eaac3 ("bcachefs: Split out bkey_types.h")
Link: https://lore.kernel.org/all/00000000000025321f061d7b62ff@google.com/T/

Signed-off-by: zhanghao <zhanghao1@kylinos.cn>
---
 fs/bcachefs/bkey_types.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/bcachefs/bkey_types.h b/fs/bcachefs/bkey_types.h
index c9ae9e42b385..60fa5af93032 100644
--- a/fs/bcachefs/bkey_types.h
+++ b/fs/bcachefs/bkey_types.h
@@ -21,6 +21,8 @@ static inline struct bkey_i *bkey_next(struct bkey_i *k)
 
 static inline size_t bkey_val_bytes(const struct bkey *k)
 {
+	if (k->u64s < BKEY_U64s)
+		return 0;
 	return bkey_val_u64s(k) * sizeof(u64);
 }
 

base-commit: defaf1a2113a22b00dfa1abc0fd2014820eaf065
prerequisite-patch-id: 1ec511753fc7aab35ba0e982013cf91ba4403da6
-- 
2.39.2

