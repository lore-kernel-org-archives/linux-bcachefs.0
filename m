Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86B415B980
	for <linux-bcachefs@vger.kernel.org>; Fri,  9 Aug 2024 18:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723229110; cv=none; b=AVwYOwGle+ImSTNCmiU9clhSOXD++BxsGf2bw5vFKrgbs8SARBxpMktdkc/SfuGjrNzqe/2emWF2j+WsdBl03Pu4NnD/9y074/FCV+WgqYU0WirGCLcWu02JXXl4+MzkE6NxWaONqaQBqNmjHAu5IAGZF7jJaBfRbGG4LGnoDAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723229110; c=relaxed/simple;
	bh=Q3VYbwM4CKv9HZE1IBds6JfYLVoY9EDuZvS5XcFcfQs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gk6doW0i1wimdzA8sU+yVitt9KtZ4hQNMykWrFz4rzSz/rBWgOr6kKRRSWreDhxMHe2K4Bm1hLCP4VrY2euV1QLaQK1GtRJ+wHCrs4MEeEZZ/20ooynnRcqfeIzyGAeiZRF3X/ePVakAfX18KWUmtK4af/VEwHIzJrSnBF1zaAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=V8N8AXrc; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="V8N8AXrc"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-6b7a3773a95so13476476d6.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 09 Aug 2024 11:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723229108; x=1723833908; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IDO1PsR4jqBoDIDFjuXXy+JZDMdVbZ460dPfM2iRCeI=;
        b=V8N8AXrc8Tophwmdihr2jPqxq4jJHG9VIu4uh5zy64A/qCovGrFm6cVCbIdWMXGMet
         UBiiu48dAs/K24Z+jsdH1VglOykWrwFg52aw0FkboIDdWpw1kMja1ENTqmRum8/Rhpzl
         qrJKvtHDHoCNXFAkORf5JPGavFFttRqhodvfw4+7v5OsWH5uXq7FmTY8ViAFjqdVJYTm
         ptV4/016K9BeQXSl/m+WI+hV8qWlFt/NNCJFIaSkSvbtmZnOFzTBFtWWB3uGLO/F8FgK
         BBDbmYh2arQkm/HaeWsP8hYyTzbrIceOdpFWLIgd9bhWJcoKoINRwEqkyeqhj0mvLaU2
         fTNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723229108; x=1723833908;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IDO1PsR4jqBoDIDFjuXXy+JZDMdVbZ460dPfM2iRCeI=;
        b=pSBzrmKStG43uZtjv7gGSBI8qXp76cpuKisHz0rrBDmxICMtkGteRhyNnbTP7rcjQf
         gvueUkIXLbUO8bAEsEgltZT14n6p/Oj12vCcRUp5yUDgUtb4YQ4bCMJdId7OBa8c/uwC
         HPk2VC8pnhngquAUoYb+jK2rYAd8DRu4YVQPKLTTqKBwaJiXYWKLZ7BZ2/iqUICrL55S
         nt0CrzQUcPXrczRn1yAbUzUI5dgYlqluVeYmTKgCD6V4fAmGq0C51jM1Njm1C3V2oAQF
         rY23UUMlTY7OaSPrSxVq/ujvPBouVl5GXuJEm0M4cvk+aoYWWuirJtaX7ONnWRzClWXs
         Oi/w==
X-Forwarded-Encrypted: i=1; AJvYcCXZxRW29I9j9SiBKY3i8y8P+0a9yGae39gbp2Y9h+Nf/r3ZBccBhIAd5zmul/jFIUR/cT0SgnM+M7VNw8+eN9JhFReOjJxjD9M86THh1pc=
X-Gm-Message-State: AOJu0YypnhgPQ59gSB3tnA0zZiRGQ0LstjZL5AuGAwE7uGsEY55DsirY
	eYjg1CWeq6W/yaj2YRN5t37meGL8LsphxPAq+1kyenx8FoB77zEKPB2OUKx9q60=
X-Google-Smtp-Source: AGHT+IH+QOHr1Jw95dRUxKTYJIvCuDQNdqmK16DNPDUQfuN+sirN+dzZW6uvQosVJ13qJ4kSzRWcFA==
X-Received: by 2002:a05:6214:2d4a:b0:6b5:a945:ec51 with SMTP id 6a1803df08f44-6bd78f29787mr25895386d6.51.1723229107924;
        Fri, 09 Aug 2024 11:45:07 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bd82e33ec9sm606886d6.77.2024.08.09.11.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 11:45:07 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 12/16] mm: don't allow huge faults for files with pre content watches
Date: Fri,  9 Aug 2024 14:44:20 -0400
Message-ID: <d6d0c9d4ccaeb559f4f51fdb1fb96880f890a665.1723228772.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1723228772.git.josef@toxicpanda.com>
References: <cover.1723228772.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There's nothing stopping us from supporting this, we could simply pass
the order into the helper and emit the proper length.  However currently
there's no tests to validate this works properly, so disable it until
there's a desire to support this along with the appropriate tests.

Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 mm/memory.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index d10e616d7389..3010bcc5e4f9 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -78,6 +78,7 @@
 #include <linux/ptrace.h>
 #include <linux/vmalloc.h>
 #include <linux/sched/sysctl.h>
+#include <linux/fsnotify.h>
 
 #include <trace/events/kmem.h>
 
@@ -5252,8 +5253,17 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
 static inline vm_fault_t create_huge_pmd(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
+	struct file *file = vma->vm_file;
 	if (vma_is_anonymous(vma))
 		return do_huge_pmd_anonymous_page(vmf);
+	/*
+	 * Currently we just emit PAGE_SIZE for our fault events, so don't allow
+	 * a huge fault if we have a pre content watch on this file.  This would
+	 * be trivial to support, but there would need to be tests to ensure
+	 * this works properly and those don't exist currently.
+	 */
+	if (file && fsnotify_file_has_pre_content_watches(file))
+		return VM_FAULT_FALLBACK;
 	if (vma->vm_ops->huge_fault)
 		return vma->vm_ops->huge_fault(vmf, PMD_ORDER);
 	return VM_FAULT_FALLBACK;
@@ -5263,6 +5273,7 @@ static inline vm_fault_t create_huge_pmd(struct vm_fault *vmf)
 static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
+	struct file *file = vma->vm_file;
 	const bool unshare = vmf->flags & FAULT_FLAG_UNSHARE;
 	vm_fault_t ret;
 
@@ -5277,6 +5288,9 @@ static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
 	}
 
 	if (vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) {
+		/* See comment in create_huge_pmd. */
+		if (file && fsnotify_file_has_pre_content_watches(file))
+			goto split;
 		if (vma->vm_ops->huge_fault) {
 			ret = vma->vm_ops->huge_fault(vmf, PMD_ORDER);
 			if (!(ret & VM_FAULT_FALLBACK))
@@ -5296,9 +5310,13 @@ static vm_fault_t create_huge_pud(struct vm_fault *vmf)
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) &&			\
 	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
 	struct vm_area_struct *vma = vmf->vma;
+	struct file *file = vma->vm_file;
 	/* No support for anonymous transparent PUD pages yet */
 	if (vma_is_anonymous(vma))
 		return VM_FAULT_FALLBACK;
+	/* See comment in create_huge_pmd. */
+	if (file && fsnotify_file_has_pre_content_watches(file))
+		return VM_FAULT_FALLBACK;
 	if (vma->vm_ops->huge_fault)
 		return vma->vm_ops->huge_fault(vmf, PUD_ORDER);
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
@@ -5310,12 +5328,16 @@ static vm_fault_t wp_huge_pud(struct vm_fault *vmf, pud_t orig_pud)
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) &&			\
 	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
 	struct vm_area_struct *vma = vmf->vma;
+	struct file *file = vma->vm_file;
 	vm_fault_t ret;
 
 	/* No support for anonymous transparent PUD pages yet */
 	if (vma_is_anonymous(vma))
 		goto split;
 	if (vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) {
+		/* See comment in create_huge_pmd. */
+		if (file && fsnotify_file_has_pre_content_watches(file))
+			goto split;
 		if (vma->vm_ops->huge_fault) {
 			ret = vma->vm_ops->huge_fault(vmf, PUD_ORDER);
 			if (!(ret & VM_FAULT_FALLBACK))
-- 
2.43.0

