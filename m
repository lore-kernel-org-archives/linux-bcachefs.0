Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BED01D1F46
	for <linux-bcachefs@vger.kernel.org>; Wed, 14 Aug 2024 21:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723670783; cv=none; b=No/wXo5pfrRDXvUB5nM9mrcrs9/H/s4LggKe4I3s0vNH+eOvrWtFuVFrqHT8w2zfwh8PfiI7DmAk9fQXzdDjvORP+KExS4aKxsNkbFg+AkRAiJ1uoVnLz1fxU7vLiumEzWSuFO917ZusCkw7OfO5xDzTyn6fNvHWdPSPpxVGM+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723670783; c=relaxed/simple;
	bh=NSHxxZRLFbsIgAXbtW5uSuQCtRZde7l6XJ/+Bc0hmhU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CHltL46zwwJQRzItxTP+dzSe4Um7LDyyWXCvN8Vg189MsPoanTs2B0T0IOXwQfOyAItIbVzyCk/h8ZuAXJOOh8wlWomZN618VTZGq2HhuAj/mU3Zv5MG5NROySF6kP2njUJzk6/nrPVRI3cU59SW2t4/GVmx9TWOJxUwk4wchUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=JkBpJjdH; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="JkBpJjdH"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5d8060662a1so235208eaf.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 14 Aug 2024 14:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723670780; x=1724275580; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nOXg5Kh3dRzVUCha6XNrLJPIFEv9dDgQMOq3uyVXRLk=;
        b=JkBpJjdHT0nr8y7rL8HeY2I866l2ae0wbXcN22jjs8VfDIDzAU7TwCjd0SowQT0Pp9
         cH16jFw9xISJc3kn6MjOn+w/Bzkm1V970jOmuzvCTbD9vacuRiG0a9gtwpcnRwMz24Du
         MTP6wcx8anMOCNqYbIJWOo7bgNjY54IniLbtrBGePpdTAaV9p97fG60F9cApSCn8gofZ
         Ea8GDSl/14hEMp23KrnI874k+3gig+mrKcC98nTUmh0waf8jLw57j2B0N92xGbr59B7f
         twbESphI5/jr7Lkxx1tuWVF9g5HAMaLJYD6W51K8PHahW2K+w+9pfVEDo87m76zvNb++
         SeRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723670780; x=1724275580;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nOXg5Kh3dRzVUCha6XNrLJPIFEv9dDgQMOq3uyVXRLk=;
        b=gVQlG3nyPyboeAMj4adb/xJsdt6jBw918zFy0qdqM5+5nGC7yqoXCsbJ8G2aMjGjgE
         nloF/jPi1h/p2lz8ik/i8wQrYnxxXDMoyaMlfw9Veyv8SUvtlSok3f1Fvx5uw3D5P8Ip
         JchvqkMv7sKfMkqnoZtlMBNqexE3oISiQfeVizEisiEtb+6KflzdBa9GLHolyrzcWpCn
         2tJ1UlVkGuwU10Sp6qQ2HHO6PJCeDyGhBjAohskJ097vM38UvKybpnO0lLPX3469WuPQ
         gMTuWgbeXcf+MKj4WzdbgXVJ6GrYBlVGCeMn9U2sPitA4wz0aVn2rQMOU33kqD+e/ZUH
         Jd6w==
X-Forwarded-Encrypted: i=1; AJvYcCWLXg5p2saL06LJtD2NGPzlQHPnVHVvVctYt15IDmn0UZX3ELfSQFw/T6mOPDd0HMhXnsnMEHbimzRAN10OBi2bcqHdm1CimQRZIgrPOXo=
X-Gm-Message-State: AOJu0YwfF76JT9NmoDTzHydVrX8xsMIq2wpwUQvbLgPex+4Bzj4Rjcop
	VuIMdyvHT9GgZb59LD55rdsdO2/Hy+w3tFysruHVwZBGLDL699AS8GGkfc8dpLg=
X-Google-Smtp-Source: AGHT+IH8MPr5SHX8NbOpfre4Dyt2H2WS5ph4VEJ8agevnX7RI8saF6DZ/UBE7sdnWVD/jUXsHLxmXQ==
X-Received: by 2002:a05:6358:6486:b0:1ac:ec74:a00a with SMTP id e5c5f4694b2df-1b1aab9017cmr527013655d.17.1723670780544;
        Wed, 14 Aug 2024 14:26:20 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a4ff0e5b09sm8115785a.73.2024.08.14.14.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 14:26:20 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v4 15/16] gfs2: add pre-content fsnotify hook to fault
Date: Wed, 14 Aug 2024 17:25:33 -0400
Message-ID: <2bd333be8352f31163eac7528fdcb8b47a1f97b4.1723670362.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1723670362.git.josef@toxicpanda.com>
References: <cover.1723670362.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

gfs2 takes the glock before calling into filemap fault, so add the
fsnotify hook for ->fault before we take the glock in order to avoid any
possible deadlock with the HSM.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/gfs2/file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 08982937b5df..d4af70d765e0 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -556,6 +556,10 @@ static vm_fault_t gfs2_fault(struct vm_fault *vmf)
 	vm_fault_t ret;
 	int err;
 
+	ret = filemap_maybe_emit_fsnotify_event(vmf);
+	if (unlikely(ret))
+		return ret;
+
 	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
 	err = gfs2_glock_nq(&gh);
 	if (err) {
-- 
2.43.0

