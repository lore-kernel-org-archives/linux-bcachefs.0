Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E88C49638
	for <linux-bcachefs@vger.kernel.org>; Fri, 14 Jun 2024 18:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718390853; cv=none; b=em+JOUaxhv5t5P7SvDDK8uk8R+VgE2WELQD39TTkAFSyYAdhHTol+PE3+aG4iD+TwFMUNhJ5FwMkpYOJB8uRnKcbH8OqepIVkyU5LXmurNHTjTkQhlNZ2e9eAVQZfwk5SUjqMvH9maXRW2/R7XlJP6jeyhL0uuBjYM96MUrXUKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718390853; c=relaxed/simple;
	bh=C8yFICMs7ckhDoPzkNP4raGefW9T2veS2nlmqAYTMeg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mwPK51Kh9Ir9lIB6gmY2xQAmB3+13l7BfgUtqfGpumdP0xuFe5FMTbmtDoqlPga9drDl0TBxTSwWttS24f6u0T6mQis2WFF3d5N+AQF5MZcKRgC1LsJW+lhZU+SxRUACjzyuM2T/NR28zUOIVXt7Addzm8MMxtmDRkPGrXvPsiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gk4L+R+v; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gk4L+R+v"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a6269885572so619284466b.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 14 Jun 2024 11:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718390849; x=1718995649; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d3Ij1ml6lUNuGV2odv8PCVsgha+tT8PGvjOblCVJChA=;
        b=Gk4L+R+v401fiqgP0WPsEC6hreCyfAcaVZ7UotD8MxH4CgHIJTUXpsx8iok3H+UpoB
         U3tOSG0DzRs1akG/bIPo7qT39+mgQ8lNHQgQxFfCum1NZaMgEeK8869JbxPHj7dO1J+v
         aGQW/hZ5dJ6yV+VTB5I0y9Kk/v7GmhlpJ+MMoDbAzBmtcnsysPJ5yJ1qoQPQQOLRqWo9
         EV8N7DeRjxh2kabrQHgbZCcR2uxu7yawK46F0eveU1EepBE7m+DOaqLkkTBJNBxH3xyA
         v+Xh6QrZbcOCDrXY7E3lcesNSqtUtes/xJPHwUar393arprEkm+kltvsePuQ/UxW8gDa
         TInw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718390849; x=1718995649;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d3Ij1ml6lUNuGV2odv8PCVsgha+tT8PGvjOblCVJChA=;
        b=fq06B8rEUzj8I2d9+5Ub1DvMTdg8cIJQFEmAcsbuQ8RpvxsHJoRkOef3JgSutk3DRt
         ABcIcAFMZycyX580yuVRrIxxW8AqON3c2namzUumEkuToUwe8bGijwXAdkovCtxSkUwb
         YZvbrr0CKmuu1Vlf+xDcT2iaVSjSS2GWl88XKEV2crIEuLV8Iba3MjK9CNQRDwlvxFND
         nL8L74yZgnIzViumrxeyXU5vH7Wks4bT2pG2vjmryaMuJwuxR+IL2FgMWgA/u39C4qaf
         0pI/ouY/zLkaJwteFQg7fq77aFrJQUwt4Bdd30okAKmpV4nnNb6RREoxW5puHqqI0nfF
         reiA==
X-Gm-Message-State: AOJu0YwdsiwX/Mii4qV9fU6tB/uvB+j7c+VB+0xRROWfYkomkJdFYSZt
	jpKcdflRDyg/70HrtdsnEzgD2B91iFJr8MssSvXRmhBDP2zhaf9v3fBZ/PdD
X-Google-Smtp-Source: AGHT+IGMan/rJH9ncAwe7Uy1Tc7wJDJyUf1txiaIwujvKs6HjYjC13ZAwq6bmzr7Uq0e/2Agk7powQ==
X-Received: by 2002:a17:906:1149:b0:a6f:6675:6543 with SMTP id a640c23a62f3a-a6f66756bdfmr144603566b.5.1718390848502;
        Fri, 14 Jun 2024 11:47:28 -0700 (PDT)
Received: from localhost ([2a02:2f0e:615:a300:e591:7f5f:c9d3:c3f5])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56db6198sm211520966b.65.2024.06.14.11.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jun 2024 11:47:28 -0700 (PDT)
From: Ariel Miculas <ariel.miculas@gmail.com>
To: linux-bcachefs@vger.kernel.org
Cc: Ariel Miculas <ariel.miculas@gmail.com>
Subject: [PATCH v2 4/4] Preserve directory {a,m,c} times by calling copy_times() after the recursion
Date: Fri, 14 Jun 2024 21:46:53 +0300
Message-Id: <20240614184653.276043-4-ariel.miculas@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240614184653.276043-1-ariel.miculas@gmail.com>
References: <20240614184653.276043-1-ariel.miculas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Otherwise the directory {a,m,c} times will be modified by the recursive
copy of the directory tree.

Signed-off-by: Ariel Miculas <ariel.miculas@gmail.com>
---
 c_src/posix_to_bcachefs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/c_src/posix_to_bcachefs.c b/c_src/posix_to_bcachefs.c
index c66b9734..714eb47d 100644
--- a/c_src/posix_to_bcachefs.c
+++ b/c_src/posix_to_bcachefs.c
@@ -360,7 +360,6 @@ static void copy_dir(struct copy_fs_state *s,
 		if (dst_inum)
 			*dst_inum = inode.bi_inum;
 
-		copy_times(c, &inode, &stat);
 		copy_xattrs(c, &inode, d->d_name);
 
 		/* copy xattrs */
@@ -395,6 +394,7 @@ static void copy_dir(struct copy_fs_state *s,
 			BUG();
 		}
 
+		copy_times(c, &inode, &stat);
 		update_inode(c, &inode);
 next:
 		free(child_path);
-- 
2.34.1

