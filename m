Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB99816EBF3
	for <linux-bcachefs@vger.kernel.org>; Fri,  5 Apr 2024 15:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712329270; cv=none; b=EkFb1RLX7xtQiiQ7BHVSETEvBTN6A54cEmRqc6Krbsk+WeRZG737+D8YpyGSw784at8mUHWlQweuFjLejEUtxm4yPXkPpE6XClaFy8jmpkK70ldavrrC0ba/+KCt2Klgj2nIRSJFXq6kOrroTkG0STvdPYedTJgs35DBjgvZQrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712329270; c=relaxed/simple;
	bh=FDM+rqfjgcFF5IHN0e96vKKuLr3OVua6OMs3SeJABUo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=aDG/mrDgsbDbUW0rJM8Wo3kXGwr0sIpMfuRpJeObgeb+aEHGsiEpUdupEf2QZ/QE4mmpq3aGJqPyKHJeK3nClPAbEQ6Rz2m3oG584m1HBLN/7t4vGn9qS9pEbvsmEI47TdShoHxLChW215j+KXLf7GwlLHjL+Sy4tupS63FzdPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tW+/vp2A; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tW+/vp2A"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a4644bde1d4so315661566b.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 05 Apr 2024 08:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712329267; x=1712934067; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ls3xSfROj02Oi9qADH98tOOJ7brRe2Fo3DATo6V7VGo=;
        b=tW+/vp2ADq5/tEdf9Z8vMZH7zjFrfszf5L9zT9mwHzxKLFq89WJkhAStubuJ6F+H9p
         3uAL8BJyUPnGyYTKsZf230oqRGImGRi4cg5lsxLTMW8WhLF+uPG21wgO7AXTnZHp1i3h
         nFaCCDnR1ktGOc9/HUhR8jE6OV6ByGFrR+sXiqOl4lkAHHyTxF4ThMd5XDNyh6jbyyAl
         LJ0zsyT9dnllf79P+7CLwj38ZvJ3LtGnYYAgOqV+EysZ7MP8XHeAXQLsOU3gVceXh826
         4y0IXsQHBTGvA3xROWC70MQxDA4ig3QyCBsMfLQRw9XU4WckqxfLeImkl311WINcQ5Kk
         6zFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712329267; x=1712934067;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ls3xSfROj02Oi9qADH98tOOJ7brRe2Fo3DATo6V7VGo=;
        b=qecoB6a2npUtjTfqj2G2PWcNDxMlhkCykPrpTZX/ixrGxFB/n7bcto1R8ItsMzZ+OW
         TT/aFAGnPhG1cmT3mUWz5Pbf+/tjxsxGsp/JoIAmSuErJbL0jyIDKOH/SLYMWOR73ky+
         tR6HzkSQpsSchAfSq8kTKFzS/p4gB1M+rjTalL+WLaeTgero5oSLxVd7TXlYrPf7rXHu
         T64om7/ORQuywyAsbk8V6VSQif0wZIDA6ceC283QX1+d6jXrBDf4VptOcrbs/jDWYL2E
         9X3QJgLA0TPgVpMkmhAyeNbVUpRV2nps2JcydMR+Kn7m0CrRA7CYgBx2Moe3VXbDIeUz
         VotQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLP495V/AjmI8v44PTwwG9J+8bIAGyrPR4n2rCUKhZSxiRuJELMCcF+Chp38zk4GTnIRa3MukNKS6MoHYHs+lh99dXzi87mey0MqpZbxY=
X-Gm-Message-State: AOJu0YyCXD0Ze8+9Lispyx30TYuW2JboH0cSkKb41DZ5Y1sp0VaKO8jA
	2VP67fSxDAUxbdTmVSU+TBJmtTlP/7dYuvRD6pREJ187wNEa434DYKtz0FOEiAY=
X-Google-Smtp-Source: AGHT+IHKy57nSuGOHzyW+AHTWzhaIS8bsMFdSatM6N6CkW3nKL+4boqP2WuHmw6B6CE+NVXx+7nQUw==
X-Received: by 2002:a17:907:7245:b0:a4e:768a:1445 with SMTP id ds5-20020a170907724500b00a4e768a1445mr1664506ejc.16.1712329267179;
        Fri, 05 Apr 2024 08:01:07 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id jx24-20020a170907761800b00a46baba1a0asm926271ejc.100.2024.04.05.08.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 08:01:06 -0700 (PDT)
Date: Fri, 5 Apr 2024 18:01:02 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] bcachefs: fix ! vs ~ typo in __clear_bit_le64()
Message-ID: <5ecccc80-70b2-4c04-8c09-1113fef3e515@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The ! was obviously intended to be ~.  As it is, this function does
the equivalent to: "addr[bit / 64] = 0;".

Fixes: 27fcec6c27ca ("bcachefs: Clear recovery_passes_required as they complete without errors")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 fs/bcachefs/util.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/util.h b/fs/bcachefs/util.h
index b7e7c29278fc..de639e8a3ab5 100644
--- a/fs/bcachefs/util.h
+++ b/fs/bcachefs/util.h
@@ -795,7 +795,7 @@ static inline void __set_bit_le64(size_t bit, __le64 *addr)
 
 static inline void __clear_bit_le64(size_t bit, __le64 *addr)
 {
-	addr[bit / 64] &= !cpu_to_le64(BIT_ULL(bit % 64));
+	addr[bit / 64] &= ~cpu_to_le64(BIT_ULL(bit % 64));
 }
 
 static inline bool test_bit_le64(size_t bit, __le64 *addr)
-- 
2.43.0

