Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B4F11CA1
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Jun 2024 04:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718859532; cv=none; b=jovS+eRuQs63+RBhsZOdp9AQar4llR2yEkISpTAxktOTZBkPRC4F6k7WiS/idYMcK8m4mbv9kkfEqNXC9SoTz0dmJ7f23yNVgfGfLTIkfHpmkkTYAlo1Se9oeVuwgpQnT3Zyt7DS7W6eWwqYhRTdzQ4ftazvpIvkeSjTX9mb8z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718859532; c=relaxed/simple;
	bh=dNX0ViTR+Yk1IYldBqbYtiW0yb+DtqSiMXGX00c2Zvg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pgeSsQw+rBmKv43T/v0Izuam+nDTv6HLwqU7yMWLtBOMlvQrGC2Smfz0v7uSoRV7bR2M6wjOMTrBkoFuvGejGLU3yY08zV2fLVNXQvBpbR69+EgBO6EhczBDIUf/t+vVnoqkUWYSwMzUk5AKGjTdK2enEGihgsn+7Mto+itSh1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wLPvAYx0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gDad0hHu; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VnfgLvWl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yLUg/DzS; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wLPvAYx0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gDad0hHu";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VnfgLvWl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yLUg/DzS"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 85BEF219EC;
	Thu, 20 Jun 2024 04:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718859527; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LdLTKVdOtBBQOp/cgXxFHkilCgkSEvTrArHg5j0mEIA=;
	b=wLPvAYx0R2uurWgGNPtPa50hamGa5/J6yOmi1tQe0XbGFMxFBj1/ynKp8aqFCDSNpjLtIo
	9A+zBNUw1EeBhEgGuHn8oboiPu4UcJ720sh9ba/MzJPFZvJ1gbODOhiO92WvdxfgEM98pA
	n0oGfi6heUO+gDTG+dSKFNow3khxDjw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718859527;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LdLTKVdOtBBQOp/cgXxFHkilCgkSEvTrArHg5j0mEIA=;
	b=gDad0hHuf+2gvZU+HKlcL+YlaERAo+visBAgW22o3aDaMayAFmsrv3ReghCg/QRNUM253v
	NPiqzLkHDtKMBxAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718859526; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LdLTKVdOtBBQOp/cgXxFHkilCgkSEvTrArHg5j0mEIA=;
	b=VnfgLvWl1uSLME9LUswLv/x9C6h8YwpfbOwHkWHodpu2VbVk6JX2HxHx3CWtTwsqdcK2XJ
	6ulWrC801mpgEQlEcGEdzYtOQcjIYDcjNf7il0IkCJH/e6V1lAYym3BiYrCpgx/nbIlwC2
	+Il5zBeaAKZMeNSnlF1YCQBcSdxzjHY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718859526;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LdLTKVdOtBBQOp/cgXxFHkilCgkSEvTrArHg5j0mEIA=;
	b=yLUg/DzSQP03VdvLW0wygoHe3y4d0ykWIYGRz3kwG3bH9iwwne/XWl152s1605OYsl6qKK
	UQEDZ4RLE/ErOtDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3C15B1369F;
	Thu, 20 Jun 2024 04:58:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eMX0NgS3c2bvIwAAD6G6ig
	(envelope-from <ddiss@suse.de>); Thu, 20 Jun 2024 04:58:44 +0000
From: David Disseldorp <ddiss@suse.de>
To: linux-bcachefs@vger.kernel.org
Cc: David Disseldorp <ddiss@suse.de>
Subject: [tools PATCH 1/1] key: use c_long type for keyctl_search() helper fn
Date: Thu, 20 Jun 2024 14:58:05 +1000
Message-Id: <20240620045804.27888-2-ddiss@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240620045804.27888-1-ddiss@suse.de>
References: <20240620045804.27888-1-ddiss@suse.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.85 / 50.00];
	REPLY(-4.00)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	BAYES_HAM(-0.05)[60.31%];
	RCPT_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -3.85
X-Spam-Level: 

The keyctl_search() C function returns a long, which is already
reflected in the KeyHandle._id type. The search_keyring() helper
function currently returns a Result<i64>, which breaks 32-bit builds for
e.g. armv7l:
  error[E0308]: mismatched types
     --> src/key.rs:121:16
      |
  121 |             Ok(key_id)
      |             -- ^^^^^^ expected `i64`, found `i32`
      |             |
      |             arguments to this enum variant are incorrect
...
  error[E0308]: mismatched types
     --> src/key.rs:135:24
      |
  135 |                 _id:   id,
      |                        ^^ expected `i32`, found `i64`

Fix this by changing search_keyring() to return a Result<c_long>.

Fixes: f72ded6a ("fix(key): search for key in all relevant keyrings")
Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 src/key.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/key.rs b/src/key.rs
index 96eb491d..0e061ee5 100644
--- a/src/key.rs
+++ b/src/key.rs
@@ -110,7 +110,7 @@ impl KeyHandle {
         }
     }
 
-    fn search_keyring(keyring: i32, key_name: &CStr) -> Result<i64> {
+    fn search_keyring(keyring: i32, key_name: &CStr) -> Result<c_long> {
         let key_name = CStr::as_ptr(key_name);
         let key_type = c_str!("user");
 
-- 
2.35.3

