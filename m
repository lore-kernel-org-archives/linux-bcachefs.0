Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB631E104B;
	Tue,  8 Oct 2024 20:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728419143; cv=none; b=MQjxruaHgccjlRRmHvopJUe+vOmxHboP9apN6xc7/EG3G/D74bm/FIUVZAJgLRfWZN3aPq8Pe10UHJH9zEkOjeXLLNFTktzp7NIl4NSXrZl5iXD/0FImj3DNGVd2C9OeYHsMNo7tOzn7x+w2uaPP57ZdKOmSssyQpOqyfGrfmJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728419143; c=relaxed/simple;
	bh=+62GWsOwVBdhRHetxkZdgjXnt+BdlwrrCAhsBRIYUmI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XV90/hhH2CaZVVPyV7a0Cr2I75v+eBI8WahwO5tUrA5SbTgY6aEmwz358H9Iq5qsFyrYBxf7/mBt0Xtbh+d00trQGH6ESuo/gQyx35w2yqoG7lEl6/iQMmZui/ewjEPliVgL73IU3RWMTz1AZ3gXBupikmtJmRTy5mu5g/xWAGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jPpNZf+E; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jPpNZf+E"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-20b1134a6b0so5534735ad.2;
        Tue, 08 Oct 2024 13:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728419142; x=1729023942; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fHFfcjP7e63aVrsj9S3xIwQfv9rNqIN8h79VM6VgqSw=;
        b=jPpNZf+E+Ac1WEHNIfTAuemRNix4FZx3ZWvNFAN5gIbjD5FmOFus48t6ArZ6bnxZAk
         Agyg55Bo0nMGsQqxURj1qrJ55lEtVdC5TUj6WfSufiLKD9sKovvlWpcvbhAOWZJnPAde
         vlbXJB05cl2A4uBUaxdlSE90Cq5eKW3aysgSCAsrirWlr5n4js59JsygxLTumgevHeTb
         Ipt90xtfJphyl1cHLhoZOR+vblxU/eo+p0pICbJRly9/TvyoGZ7zRmn6EsBXiC/0wejC
         MMBV2a+bQTHCGDajaRzJHvLcoLhV92kld/ab/dOhGjTmXOE1RNnRzaiUx+evF7Gjf0gi
         PJKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728419142; x=1729023942;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fHFfcjP7e63aVrsj9S3xIwQfv9rNqIN8h79VM6VgqSw=;
        b=MaJlVmUuwthcAZ52zEUOnL/OENGkPCzg4lNDUzQEl9Lkp0lq8ESeNrrcxCVBDOAmjC
         CC4rhTowUac5Igp+Zzn6W1WgMShs2rEFhMI9jSw/s5RdWtgYuM9U5r8PuVMfmimaQlvC
         qjmUqo7B7QoDKK+heAWo/ISfaQM3HZHNOZpb3OVhO+f1cZWhbyp2Ux7+GxbbRy9E2kcS
         ZBeNeUMUV4JwhJGQZtrE731nLFZvh3Oj02kPCwGFNhAXZPuYIuK2Wkk4g3w8ainyDrtz
         +dyd8RvOQ7L9zYPFNVFVPUEsz6jQPTAG7Q6sYM2RMK3dRqy1ZpmfYmOhkKd4VZSEL1vR
         j4sw==
X-Forwarded-Encrypted: i=1; AJvYcCW09hCO6DC0th2dJx2Ym+uHP/fWniJ2Fllks07N1OosvkgIzCWDqhVmuVFPXTczWbOsNmIkzoRT/CqUWHkmMQ==@vger.kernel.org, AJvYcCXRiKhvLFUmmQD/JBor/Ump5YxX7ZVaMhZ6GogTlztSwEBGH1mvIA9ag4w8U71d40n13eT/5qxWSMoMlXwn@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6wwXyMYST8MLFlu3oOlTcReMmiUK/um+UU1QsDj/23aIElt45
	bqkKLK+wUUZwONHcFxnGmRjZwMOzvXuA1vbt+1U4ifiWrf09PF97
X-Google-Smtp-Source: AGHT+IFODThhy7hNypCxLh2wteGm9CvuNfcjriQqFrwNXwNktxCk0xzdBP2KCGYk7wxShucokLRKTA==
X-Received: by 2002:a17:903:18a:b0:20b:7a2d:c543 with SMTP id d9443c01a7336-20c6358f83cmr1687775ad.0.1728419141603;
        Tue, 08 Oct 2024 13:25:41 -0700 (PDT)
Received: from ice.. ([171.76.85.17])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c62f11757sm1054145ad.19.2024.10.08.13.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2024 13:25:41 -0700 (PDT)
From: Nihar Chaithanya <niharchaithanya@gmail.com>
To: shaggy@kernel.org
Cc: jfs-discussion@lists.sourceforge.net,
	skhan@linuxfoundation.org,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Nihar Chaithanya <niharchaithanya@gmail.com>,
	syzbot+412dea214d8baa3f7483@syzkaller.appspotmail.com
Subject: [PATCH] jfs: add a check to prevent array-index-out-of-bounds
Date: Wed,  9 Oct 2024 01:51:38 +0530
Message-Id: <20241008202137.8577-1-niharchaithanya@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the value of lp is 1 at the end of the iteration in the for loop,
lp is modified in the next iteration to a negative value.
Add a check to prevent this condition.

Reported-by: syzbot+412dea214d8baa3f7483@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=412dea214d8baa3f7483
Tested-by: syzbot+412dea214d8baa3f7483@syzkaller.appspotmail.com
Signed-off-by: Nihar Chaithanya <niharchaithanya@gmail.com>
---
 fs/jfs/jfs_dmap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 5713994328cb..3ebb2dfdd0b3 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -2911,6 +2911,12 @@ static void dbAdjTree(dmtree_t *tp, int leafno, int newval, bool is_ctl)
 		 */
 		tp->dmt_stree[pp] = max;
 
+		/* check to prevent negative value of lp on the
+		 * next iteration.
+		 */
+		if (lp == 1)
+			break;
+
 		/* parent becomes leaf for next go-round.
 		 */
 		lp = pp;
-- 
2.34.1

