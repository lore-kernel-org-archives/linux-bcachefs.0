Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6A2376E1
	for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 14:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708351755; cv=none; b=BbOYMz9UDrLA5mPIM1W3lvKbh17dDZPYDOtqMRtBIF8PeCPtduqzs7w66DLx6E9GgZAzMyqi5CkxoW5VcAn+uTpfj6iaFNDpcIP8AtlXjvO4KNXMMbMa1yk0L209TEFqFCx40EsgXnqTVONCCZgspWIMQSnA6Zhf3UXVoz/0YDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708351755; c=relaxed/simple;
	bh=dawbDDo2wJJKwknolMK8HeskidHNqCqVdMvXKuokBGo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hKOHyaQwYZzfOcYzbe3hS4rG6fOU0ujoyHrgRe16LCU34KQSv1JhbFrHyjzWBlQi56IxINQWCEXYE3I0W1Y4ZK71CYVa2GJGcxSLpWre40348lc7QUWDngqpxOgHXqUL3Hgi7rXYn9+gtnWK82JdUIix7RWCt5RlEUErI2DKiT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gluo.nz; spf=pass smtp.mailfrom=gluo.nz; dkim=pass (2048-bit key) header.d=gluo-nz.20230601.gappssmtp.com header.i=@gluo-nz.20230601.gappssmtp.com header.b=BOExzCTQ; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gluo.nz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gluo.nz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gluo-nz.20230601.gappssmtp.com header.i=@gluo-nz.20230601.gappssmtp.com header.b="BOExzCTQ"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-36423c819a3so18248405ab.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 06:09:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gluo-nz.20230601.gappssmtp.com; s=20230601; t=1708351752; x=1708956552; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PqY0epIFDP2EOF4FzoyeRTrfsjYZXh9/SMfhM/Fvcxw=;
        b=BOExzCTQxMOr9Itm4ZfivxMJFdrzMkTyN5/zugpbVOVkzvjVO/1KZonktRB3BJrMod
         XrmEql7jVG9JrzSos+O/KVD2S0X0T6ASy+WNCNFuYlNLhyh0LtBnDuf8J2JcjWzhp1c2
         uLwjcTkhaNPaucONEFtn1LQdrSZPtTkKnRw0+xzbg4ZeBdIXmPxWJM+m27Ih4Pm6YSOu
         G5papKDIrW6TakpPXSKOUbmMxKcJWgHsE1ZNQSL5kVtW3u/gV5lla5uZH8AeeLOFc0bh
         7/l+S9qoE7TqmBL1SEShZoMKk+KEtrKYqgq2r+wkwO4pdvrjjBAsMP+h3SpbQD1FQf37
         JKMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708351752; x=1708956552;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PqY0epIFDP2EOF4FzoyeRTrfsjYZXh9/SMfhM/Fvcxw=;
        b=s+CSa6pV/ZXH/wF/VxjkJQPnk8m3TU2QieBD86iH+/her0iKsXKSi1wWc8LhY+g3+V
         HqM+gym82Vq9RC+5HucPYQ28TNMBYtwHPQGp8lHIWyiGTzx7mhBJ2CjUdvYqcYCORVRU
         ViYX1z9Ol3WcbGRj4dAqPx0wILNfvoaIEdvd2EFCUpzqrWMTrnA1b0MDjcadl8bzLuCx
         DyCHX/XUHa8h8O2+MP9bRn2wznzV/4JhHtEoQk5YGO8v+JX9zkNyawecA5zkDmlpfBit
         BxUBUqGGOVd1O8IyDYXB4PK/of96hgFFyvBxGtgCLgMlTAnTEPtEsMpHsyBeCozTLqf/
         ZW+A==
X-Gm-Message-State: AOJu0YzJ6mjbzu3uxEn8YaKqfKPvhTCOvFJZS0tJeW5RM8z3VABdw3Cw
	HWnuagRLpioaVBsMJZnAor2wsWjzYAxw5WK14mz+0trFpuY/bJc+xGlDFTXscZeRilFiIVV49A3
	z
X-Google-Smtp-Source: AGHT+IGY15+B/gxZBQubj4VaPT+5VyMaG3WCMXckgsatzrj21H6LWHjcPuohUePHd7MhvrFnI9WB8Q==
X-Received: by 2002:a92:ce03:0:b0:364:ff2d:8989 with SMTP id b3-20020a92ce03000000b00364ff2d8989mr9580005ilo.31.1708351752308;
        Mon, 19 Feb 2024 06:09:12 -0800 (PST)
Received: from Purple-Sunrise.. (125-239-189-189-fibre.sparkbb.co.nz. [125.239.189.189])
        by smtp.gmail.com with ESMTPSA id dq3-20020a056a020f8300b005b7dd356f75sm3973840pgb.32.2024.02.19.06.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 06:09:12 -0800 (PST)
From: Daniel Hill <daniel@gluo.nz>
To: linux-bcachefs@vger.kernel.org
Cc: Daniel Hill <daniel@gluo.nz>
Subject: [PATCH 0/1] bcachefs: copygc: remove ambiguity in bucket struct names
Date: Tue, 20 Feb 2024 03:08:41 +1300
Message-ID: <20240219140857.901012-1-daniel@gluo.nz>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Having the same variable name for different structures is confusing, lets fix that.

Daniel Hill (1):
  bcachefs: copygc: remove ambiguity in bucket struct names

 fs/bcachefs/movinggc.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

-- 
2.43.0

