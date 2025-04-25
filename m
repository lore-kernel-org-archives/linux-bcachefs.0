Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C84923BD02
	for <linux-bcachefs@vger.kernel.org>; Fri, 25 Apr 2025 10:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745577613; cv=none; b=pY7KX2RsZqK8E5O9d4mAsSM/ml3I14bsYXw5CEA55QbToZBZNeIJIGVHYHoVTgYWB7JJICHyaGoYF7NjpPt93Kc6TW+g/BnflgMKxrvZgq8qfkBVgS1Rv+Eaz713/OxhvQnRlSFX2sUJzyVwK4JcfF9shF6kdu2uKEzH8dcUTzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745577613; c=relaxed/simple;
	bh=6RJBR7aP//7uX1zwEhkxASwnGR5jpBo7hJVRZCHUz4A=;
	h=Message-ID:Date:MIME-Version:From:Subject:References:To:
	 In-Reply-To:Content-Type; b=QXcCtd7wg/NTrP+cuQYdkYsbWTUeT2LzvRYr09QN8RvyhQYdxraOvOM+SPAhPWipX5cox9jk9mygZoJay14EQtuTsrPBNPZLw7wOcHixhip7r4oEdQ9lJEetjkmnn4NQsz3DeA176bc1AJbH50Ay2Uh6yQCYSDReNE33oY7rGcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gxQkowN4; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gxQkowN4"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-43edecbfb46so13728895e9.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 25 Apr 2025 03:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745577610; x=1746182410; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:to:content-language
         :references:reply-to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=6ZubTCE1is//Ch4Usyi0ZEwxEQ/PxG/0zvtcpznhCbg=;
        b=gxQkowN45NmJBLtbZOJEPb2EXTv3skDw3kh9UcTbb/6xFtiExjAs/bYrR5IcaQSjdc
         tUOKsiinJh7kL8tz6Hmpg1IhhoT8qBhPdUfTwnKw1zCTwROMn6nITw6KC9dWz174P5zl
         yfIszIWS6VEmEN77/4wdbhkvOFtirU92Qt/DF7C0XTx+H65LjlKFtLZtvQHzeKp9r37F
         BKAsGB54okDneVhzwjtdlkB2jNq2sD65ehwYLVLCVFf7PrpZwP92t8GvkBCtPqEDpCMs
         gPdYP9PCnD6sN6thZLXMZmsWmiKt7jP5XdLzVikCApcLVE+aC2LsekfsJ83fDcVP+ov1
         ua6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745577610; x=1746182410;
        h=content-transfer-encoding:in-reply-to:to:content-language
         :references:reply-to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6ZubTCE1is//Ch4Usyi0ZEwxEQ/PxG/0zvtcpznhCbg=;
        b=atrVeNhGHOBk9dbSd3jKqrgrUpGJJC8vCTqrfF8zNRqf3ZLvdCjD1gnWJv0IIZ61LG
         8QprHSN5BuZ1N1Ui+xv6uUNs7u/FHKe+Q3CCEZlhoMNFQ/Z4ut6AUsO62Ol+Da2AEsgs
         cu77Konehx2aiGtykFX7m6AiTOjlz1Ojm4XYHcf+sBxyMI3wM9KDvKGkOCrZNJmgq7+w
         NtwdX+CvyOmVv1eqNHeurU6p8AJDOmEUzk6lPwQlAf/183WeugiAlMcx2eG0zVNU6gRU
         x6e+cCghGAaNN9toh2quPRIdupLgU1TPG4nvwJSkdF2MGWyvrkvfA4DqMexGw85mggr0
         LBgA==
X-Gm-Message-State: AOJu0Yyxkif5DlJHelfkk6sd4++dJTCP5gfyHJfoiJuCvWteQK8PCiQd
	jGqmVDrBQnbVxdLsnn6/Me5ARewA0lzCmWdir1DIEXldl46Hcvw7q4yfTA==
X-Gm-Gg: ASbGncurmq/C+kd2mBaBhaBdySByqT2CdumsWVfuqvRt0C8OrKd+1JN30mgMTJxcLY9
	IVGZMrVA+Qsmv4/40HZIrQn+vEYr068mGQM1xobi16BFA0oXtc5HtZKMI58PrW6Bbyb7d9q1Q75
	72U75tYfuyUA6q5TLRri7Fs2dRXVCUk5lkbmnMdcbaLIjawK0SNliYqxhKhl57a5Ipmums8Eijk
	ZV+Nn9r3N3V/RjYsGPxcoDSFgSQUWoZF/Ckn+EJegfb3pNaTGGaxAi1Z8uoYjlOlUmOmT2zAUt1
	KcX+ahEkdyGlyZAZBbDLntsM2fgdCJG/GPl0LXZ+H3W1cYK4hpT4DRwUq4y730+Ai6z7yQj4/lS
	qz95XTSxN1MkORFaT
X-Google-Smtp-Source: AGHT+IEIIhMdgx9GLzBkJ44lPDaxm0vMTqN8zbcU001klC6GTf7hxGz9Q1687KgHzmAWcp8cbnU+dA==
X-Received: by 2002:a05:600c:8411:b0:43d:a90:9f1 with SMTP id 5b1f17b1804b1-440a64b66e9mr13438065e9.6.1745577610097;
        Fri, 25 Apr 2025 03:40:10 -0700 (PDT)
Received: from ?IPV6:2001:861:73:f8d0:5d2f:586a:2e0c:4fc9? ([2001:861:73:f8d0:5d2f:586a:2e0c:4fc9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4409d29ba34sm54818275e9.5.2025.04.25.03.40.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Apr 2025 03:40:09 -0700 (PDT)
Message-ID: <c62a836f-c7ac-4771-ac6d-6ebe9cb78439@gmail.com>
Date: Fri, 25 Apr 2025 12:40:09 +0200
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
From: Gabriel de Perthuis <g2p.code@gmail.com>
Subject: [PATCH] bcachefs: Don't pretty-print options in /proc/mounts
Reply-To: Gabriel de Perthuis <g2p.code@gmail.com>
References: <32f10186c6b507e4ba8fc9ea36141df17a36ab3c.1745577250.git.g2p.code@gmail.com>
Content-Language: en-US
To: linux-bcachefs@vger.kernel.org,
 Kent Overstreet <kent.overstreet@linux.dev>
In-Reply-To: <32f10186c6b507e4ba8fc9ea36141df17a36ab3c.1745577250.git.g2p.code@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


Pretty printing of sizes could introduce spaces and break
the expected space-separated format.

Signed-off-by: Gabriel de Perthuis <g2p.code@gmail.com>
---
  fs/bcachefs/opts.c | 2 ++
  1 file changed, 2 insertions(+)

diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index b1cf88905b816..65dce3ce46b5b 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -461,10 +461,12 @@ void bch2_opt_to_text(struct printbuf *out,
  			       opt->attr.name);
  			return;
  		}
   		prt_printf(out, "%s=", opt->attr.name);
+		// OPT_HUMAN_READABLE can introduce spaces which break the expected 
tabular format
+		flags &= ~OPT_HUMAN_READABLE;
  	}
   	switch (opt->type) {
  	case BCH_OPT_BOOL:
  	case BCH_OPT_UINT:
-- 
2.45.2

