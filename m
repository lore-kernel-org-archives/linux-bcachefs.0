Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9651B314A6A
	for <linux-bcachefs@vger.kernel.org>; Thu, 28 Aug 2025 14:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756390597; cv=none; b=l8Uh+qdS7JTGmpm6wMCRa0jZlJkgCjxZr/pfpvb2E5TsbNPkg94jDg0pQy7heEah5dgU+xl9WRUGnOHwgF0d1VH14PiC3/bpg4eX1uUgjvYa3yKn4QEQYRiiRDNNTWWp2TYFTefCTlYKpLq3k4+gRTNWk78yTZRrh0tOlLuJ2pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756390597; c=relaxed/simple;
	bh=X9QTPgHF8th/djcqtTODEF8eULwykOryQEbDBJE7/EU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HFXkau1SU0PUEj+oCFgxTKkbJHgDELgFFrNbh7v14Gs2EY367lwm5UWCZ8buXZyRKnDWjAW0iz0dwxOKtMeSd65guEF9zPyg+0eKg/g92a5NVsbpjA0ttFiV8pW/qQYyhMjafokLDbnXkuNTK4jSIoPDDN3hmXOywmsI2Noy88g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M5dJUU2v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M5dJUU2v"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 45DD3C4CEFA;
	Thu, 28 Aug 2025 14:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756390597;
	bh=X9QTPgHF8th/djcqtTODEF8eULwykOryQEbDBJE7/EU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=M5dJUU2vIt04Z7cHwN3IZNxbRxtSEqGpkfnpJjJpCdEe5qICHz94R4RvtWCjKupSp
	 I5hmRvucp9B25XstV8wWcz/ljW/V4QuCB35+qhTL0JnEfj/Rfj5fj3rxCjCcS2UyOa
	 tpCSDd7Y34Ba+rmys5zyA0fCftHAI65HynCxp3pfMY9L3VEgmK7+2vmze5StcQf873
	 huLA15xflIjtxcQV9UkYmU8FUk97j48RX4d0d5C2cA/ogxx2d3vn6zjvC02tIVKAkK
	 bDYOGOd8jYayHeEPTWpahY3sv8X4S6qgV7yMYFZrjfegX5h/N2ZHdMLgYdg1jXHJ/5
	 TdOzXN+fh0Dng==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EB69CA0EED;
	Thu, 28 Aug 2025 14:16:37 +0000 (UTC)
From: Nikita Ofitserov via B4 Relay <devnull+himikof.gmail.com@kernel.org>
Date: Thu, 28 Aug 2025 17:16:07 +0300
Subject: [PATCH v2 05/15] bcachefs: Fix progress reporting for unknown
 btrees
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250828-better-progress-v2-5-c088a2003940@gmail.com>
References: <20250828-better-progress-v2-0-c088a2003940@gmail.com>
In-Reply-To: <20250828-better-progress-v2-0-c088a2003940@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Nikita Ofitserov <himikof@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=659; i=himikof@gmail.com;
 h=from:subject:message-id;
 bh=yQihh3I71KBB+2S7ldPtj/JAIwrsppP8EKz4G0R0YM8=;
 b=owGbwMvMwCW2edHtzWZP9DIYT6slMWRsSDl4bTHnBpkH6fsChI8IcpTVR1jFxEutnccntdnvk
 87FCbKzOkpZGMS4GGTFFFk+LPn6Z02m9R9Lob2GMHNYmUCGMHBxCsBEmnMYGW4Fep+8Nf/cok0P
 LJN0V5Uz/Cyw/CL2t6Beo3XyrWmC74sZGV6JTm2dOE1Qnrun98wy2x2Kkqpf8zUe75L/42hoLeF
 ZyAEA
X-Developer-Key: i=himikof@gmail.com; a=openpgp;
 fpr=F0A4F5FCAC693BFC3912BD31B3A2DBB336E42E68
X-Endpoint-Received: by B4 Relay for himikof@gmail.com/default with
 auth_id=452
X-Original-From: Nikita Ofitserov <himikof@gmail.com>
Reply-To: himikof@gmail.com

From: Nikita Ofitserov <himikof@gmail.com>

Signed-off-by: Nikita Ofitserov <himikof@gmail.com>
---
 fs/bcachefs/progress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/progress.c b/fs/bcachefs/progress.c
index 792fc6fef27018c73168c59857e7f3497c1969f4..541ee951d1c9fc3f11b5a5ac40f1d366829a5c97 100644
--- a/fs/bcachefs/progress.c
+++ b/fs/bcachefs/progress.c
@@ -12,7 +12,7 @@ void bch2_progress_init(struct progress_indicator_state *s,
 
 	s->next_print = jiffies + HZ * 10;
 
-	for (unsigned i = 0; i < BTREE_ID_NR; i++) {
+	for (unsigned i = 0; i < btree_id_nr_alive(c); i++) {
 		if (!(btree_id_mask & BIT_ULL(i)))
 			continue;
 

-- 
2.50.1


