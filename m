Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80A60CDB482
	for <linux-bcachefs@archiver.kernel.org>; Thu, 19 Oct 2023 13:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235402AbjJSNhp (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 19 Oct 2023 09:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235394AbjJSNhp (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 19 Oct 2023 09:37:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E762D130
        for <linux-bcachefs@vger.kernel.org>; Thu, 19 Oct 2023 06:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697722622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=ltRSh3ysnysXuqOSRu+H5VVN1GCboCRNJ1jMGzqgxmY=;
        b=fsqAXOOC9h6Pj1tK9ydO06cgJsg7b6aXpl3uiG+IvLG7ngKau6Sa2NunT7/OpLsTdiupD3
        bSaJzKTzkSmZIog5hWmK7iZ6Sxqt8CNL1KUAL39IC04xaaP++AiZ8SmHbfyYr5vJOSf1eq
        ESlUkxHd+HPIbQ2ubNZ+NZ6VZXTKSaE=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-575-67x2uW2NMCm2R0L6MdT1nQ-1; Thu, 19 Oct 2023 09:37:00 -0400
X-MC-Unique: 67x2uW2NMCm2R0L6MdT1nQ-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4199725b054so91996201cf.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 19 Oct 2023 06:37:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697722620; x=1698327420;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ltRSh3ysnysXuqOSRu+H5VVN1GCboCRNJ1jMGzqgxmY=;
        b=LWFOfQd+EqEtQedNbrQyzPvc6VyW1zdATzOj407rwovq1WcyFhDUn0BumzDQjlUYqU
         +eyRSMZS6fEHsCk8KUJ8mVzpdeK7BHKxYzBpGk75pe4XmaTgGojncLzZortVqSdS23v5
         0ZxdrgtKunURJLeFeW4aOLElCYyNqrSwys5K/AqXsuGntuzmeNpj3cAAfV45GOi7fRoe
         GytZyoxwzvgdt4pY9r7Ij73hpERQUrCJ6sgrYTqlhPSd+MfY98NWca74ykEC8UAEGIGN
         7BzgGVZ8eK/c+a/piyxNwMIY1SpIIapkzR2hRDNDB2B8x0uD6QCV5rb7PxSe71nRnrS0
         05vg==
X-Gm-Message-State: AOJu0Yyz5bKvd+ONdKtYWSCpdYayx/IwrQhh+umQWYFhYNkCDL0LodGk
        L79uPWhJ0FVg+iX+CEcSHPrVrQuis6nKGtm7yQOL6UyMvhxe7xr1Tw+KxL6brj04ZQLENBpdmFC
        1B4wNsb6GJpEAnKOFUf6yjNeYlhIrAtM/ElQnQ2enDpOEcpfXvV88mI7ayOX8pjLmBGiTTWX0eF
        VC/vj2e/3tiw==
X-Received: by 2002:ac8:5b86:0:b0:41c:bddb:fa47 with SMTP id a6-20020ac85b86000000b0041cbddbfa47mr2503919qta.67.1697722619908;
        Thu, 19 Oct 2023 06:36:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IESmRWWOHdO9Sjg77GaDmKygSOPY/tt2MgRSa8oghmjI89JFdnxM7WRDlrQR7NxzDv5Z19Nkw==
X-Received: by 2002:ac8:5b86:0:b0:41c:bddb:fa47 with SMTP id a6-20020ac85b86000000b0041cbddbfa47mr2503899qta.67.1697722619521;
        Thu, 19 Oct 2023 06:36:59 -0700 (PDT)
Received: from bfoster (c-24-60-61-41.hsd1.ma.comcast.net. [24.60.61.41])
        by smtp.gmail.com with ESMTPSA id jd24-20020a05622a719800b004196a813639sm738929qtb.17.2023.10.19.06.36.58
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Oct 2023 06:36:58 -0700 (PDT)
Date:   Thu, 19 Oct 2023 09:37:24 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [BUG] bcachefs (early?) bucket allocator raciness
Message-ID: <ZTExFP9G1fUIUgVZ@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi Kent, All,

I recently observed a data corruption problem that is related to the
recently discovered issue of mounted fs' running with the early bucket
allocator instead of the freelist allocator. The immediate failure is
generic/113 producing various splats, the most common of which is a
duplicate backpointer issue. generic/113 is primarily an aio/dio stress
test.

I eventually tracked this down to an actual duplicate bucket allocation
in the early bucket allocator code. The race generally looks as follows:

- Task 1 lands in bch2_bucket_alloc_early(), selects key A from the
  alloc btree, and then schedules (perhaps due to freelist_lock).

- Task 2 runs through the same alloc path and selects the same key K,
  but proceeds to open the associated bucket, alloc/write to it,
  complete the I/O and release the bucket (removing it from the hash).

- Task 1 continues with alloc key K. bch2_bucket_is_open() returns false
  because the previously opened bucket has been removed from the hash
  list. Therefore task 1 opens a new bucket for what is now no longer free
  space and uses it for the its associated write operation.

This eventually results in a splat related to duplicate backpointers or
multiple data types in a single bucket. The fundamental problem is
inconsistency between the key walk and bucket management. In theory, a
simple fix would be something like reader exclusion or revalidation
(i.e. seqlock type checks to revalidate the current/prospective key)
once the allocation side is under lock, but that would require more
experimentation to confirm, validate performance, etc.

Once it became apparent that this fs shouldn't be running the early
allocator in the first place, I worked around that problem to try and
see whether this sort of race could still be reproduced with the
freelist allocator. So far I've not been able to reproduce.

Note that one factor wrt to the early allocator is that it doesn't
effectively update the alloc cursor, which means multiple threads can
come through and process the same sets of keys repeatedly. Fixing that
cursor issue [1] actually helps mitigate the race as well, even if not a
proper fix. However, I'm still not able to reproduce with the freelist
allocator even if I remove the cursor updates to try and simulate the
same sort of problem there. So far nothing stands out to me as obviously
different between how the alloc and freespace btrees are managed wrt to
serialization against foreground allocation, so I'm not totally clear if
this is just a timing thing due to relative inefficiency of the early
allocator or if I'm just missing something in the code. Thoughts?

Brian

[1] https://lore.kernel.org/linux-bcachefs/20231019132746.279256-1-bfoster@redhat.com/

