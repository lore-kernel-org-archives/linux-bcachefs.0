Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73799C4332F
	for <linux-bcachefs@archiver.kernel.org>; Thu,  2 Nov 2023 12:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjKBMsp (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 2 Nov 2023 08:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjKBMso (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 2 Nov 2023 08:48:44 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F96112
        for <linux-bcachefs@vger.kernel.org>; Thu,  2 Nov 2023 05:48:39 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id d75a77b69052e-41cdc669c5eso155871cf.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 02 Nov 2023 05:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698929318; x=1699534118; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WTmKSo8v+RF/Mq93bE+btQmbxOzJmpnCpGiJADmxjOA=;
        b=Zx3y3R/tL81ILTgghTP+k6o2TZ0AAIClW9UBZbjgyHe1fCU7k3nVNDllHPDjDCvUsJ
         /w6ZonIVeFM+6hP0PpYEaoGRXl/4/utUd0yZm3qNbX5+8uLPcv/DIZUqZv30+VQZrjig
         +BfqKGIV3t3vIKM1oVdb7JcaISjXNZ2Ib/qeY/1gMZ6icZ0xEOud7dQIjaycnymtP74F
         p1650h2Zw6ajxK1qoCwi8UnfOWmLED6hxxAOl+yE72oNL0SRJG//ip3nUKgLguntk0NH
         Bsxb3pFepdblf8zZYrHLgy+tJJRgpO5qtCopTruhn+QJvfnNL1Qm3mYCE05MDMdEyOT/
         nyQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698929318; x=1699534118;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WTmKSo8v+RF/Mq93bE+btQmbxOzJmpnCpGiJADmxjOA=;
        b=cjbdJQzhdQ/5HXMO4aI4SbOrgnQZIWBLvRZnyI1cMoV2SFbycNSIobTuJTqUvCY/aq
         RaW1a6GmUgiKiXGZ7J8mrRZL0TVMuD+egAruCCidBKDbMG2obtX0Jv2gJTwQljAiFaaS
         Uhfww9YE3fMYUQU1qxjRoZgLeAHUNtmioO1A47pUh9Zv6d68f8w5gEZcsO3XptTCVnrR
         DU/+6dcNPdnzseFRAcH5t6AJkqdz5bYRsf+hEsXgr+y6lHsPkZZUpWRn5CnVAVWeoA2/
         +vfTS0ebbWCJs6+1+RHaZd6U6KccN3ru0CkQlP8A0CmPwVA7GS3W7uRt8R9jPzamxZ/O
         9UEg==
X-Gm-Message-State: AOJu0Ywuz9cfd4E7+Kl1CMZSDLhvIP04KqcIhujzpZzjB8O2VasJELLV
        VY7VKgZtDjxzA9brMqezOeeezyb2wyTb9Y6uo1AlooHWCNYyIgUG17eTHw==
X-Google-Smtp-Source: AGHT+IGRNwHxptSKVTbjpSAuXa38qtYTor3VzYb38ErO4PJC3oIvg8G/J+dfwAtt3/NS8ZEs7M2NwLeQmH8Hr4jbd4U=
X-Received: by 2002:aed:27ca:0:b0:41c:e10b:a3ff with SMTP id
 m10-20020aed27ca000000b0041ce10ba3ffmr135503qtg.3.1698929318111; Thu, 02 Nov
 2023 05:48:38 -0700 (PDT)
MIME-Version: 1.0
From:   Hannu Krosing <hannuk@google.com>
Date:   Thu, 2 Nov 2023 13:48:25 +0100
Message-ID: <CAMT0RQRwBLBBp7ufmk3mrAaVAQxPKxiGEK5t+qvE+ftRnfyvmA@mail.gmail.com>
Subject: A question on bcachefs as a Cluster File System
To:     linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

What is the current thinking around using bacachefs as a cluster file
system (CFS)?

By CFS I mean a file system which can be mounted concurrently from
many hosts or VMs.

At high level it looks like it should be something quite easy to
accommodate, bcachefs having grown out of caching work and the main
difference between CFS and non-cluster FS being the ability to
guarantee cache coherency.

So what are your thoughts on this, assuming that bcachefs is runnning
on a storage that is already available for all the hosts/VMs, what is
missing and how hard would it be to get there ?

I did not find anything about CFS support in the
https://bcachefs.org/FAQ/ or other pages.

Best Regards
Hannu
