Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B61D2CDB482
	for <linux-bcachefs@archiver.kernel.org>; Wed, 18 Oct 2023 19:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjJRTik (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 18 Oct 2023 15:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjJRTik (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 18 Oct 2023 15:38:40 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCEE95
        for <linux-bcachefs@vger.kernel.org>; Wed, 18 Oct 2023 12:38:39 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 41be03b00d2f7-5ae99bb5ccdso2959810a12.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 18 Oct 2023 12:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697657917; x=1698262717; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Plt1ulOLIOXE1pokyE/x34Ikl/hT1Uixzpaj1cmJIGk=;
        b=ARf5b6vB568TRj7EYzokmTJPyd9b3LFac/oEc8Az1KNAYz/xWKpI7xIEyMRK7ox0e+
         TKQZmTW6e/5NeCo9Vx4/RKYb623Y2S5nRDi4/ZKN+YqMuez7UqAwXxKB+9kGNZmDZ6xL
         2rSeVgzl1P/DED8jVEwaRUxqKQeuv00WmEQCcjgWhr00QejStZzHml9TnNmNONo0jw9A
         x36OtoQxOXfODc/sBwxyCi3z7cKAmhKXbqR9E6jUbt6vWsmJtzNAZ/mBNrSnN9NL7h6l
         VqL/5pI0dcKMyq1a06snypwFKR1OWyU72SyX3UewQGo9Z65g+2Q5tTvI6Y8CbQCJq3wp
         +70g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697657917; x=1698262717;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Plt1ulOLIOXE1pokyE/x34Ikl/hT1Uixzpaj1cmJIGk=;
        b=GeZn3V2Q3DEb3B/xQLRkBB54bWj9cudxMjygXa6BnTV/hcM/Re7vJVLiuue7QlXdQm
         ZivjolmqTJRnOKaBC0YamFolS7dimLHOLLG/j/TkCPFM2MH4kL12iXIc7iPXWSt1KsXh
         Z8XwtFA754nO7xhJVcUmauwZGdhyLiSxAdH4aWBYDROXmnuQoxV6eSd9iGDzPEIaKN+y
         A8uYw6vjK0Vul8ohhCDg7TmIBG93xxIKQdwaL/hwB1Kmq5W+8afgq8dLg5x18NI7qqKu
         rh3vswJMtDCUs4CdP/dzyFSvMVWK8vnd0MjUpKRH6YgbEL1xN/MxYA4RldCFJEFUB3h7
         gwcg==
X-Gm-Message-State: AOJu0Ywkrvf10/8mJypVgU/hXrrLwYTTmclnWPyYPESKqhpIrvmd4XI1
        0Xy6Fm8BkTruoVLHN5HcS2FqCLAWhNfh0WlbAnxlbXEmTRI=
X-Google-Smtp-Source: AGHT+IGmtmcx+ulMmp6dpNVGNHyJTYDpn84q9BoUrJc3WRoUhhNwmLv54E8w1FBla8xKlbzEnXXxbKR4aSZBeWDwYkU=
X-Received: by 2002:a17:90a:4595:b0:27d:1051:83c4 with SMTP id
 v21-20020a17090a459500b0027d105183c4mr148280pjg.12.1697657917100; Wed, 18 Oct
 2023 12:38:37 -0700 (PDT)
MIME-Version: 1.0
From:   Parke <parke.nexus@gmail.com>
Date:   Wed, 18 Oct 2023 12:37:59 -0700
Message-ID: <CAPxz1+Yt644v4q-ahjE46Sh_ZZSE2r=wwSaup4nYC4uYgQy+rA@mail.gmail.com>
Subject: Bcachefs: export a different st_dev for each subvolume
To:     linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hello, linux-bcachefs@vger.kernel.org,

I am exploring the feasibility of adding colorization of subvolumes to
the output of the coreutils `ls` program.  Specifically, for the
BTRFS, ZFS, and Bcachefs filesystems.

In order for `ls` colorization of subvolumes to be feasible, detection
of subvolumes, by non-root users, needs to be implemented in an
efficient and reliable manner.

In searching the linux-bcachefs mailing list, I found a post by Kent Overstreet:

On 4 Nov 2021, Kent Overstreet wrote:
Still todo:
   - need to export a different st_dev for each subvolume, like btrfs, so that
     find -xdev does what you want and skips snapshots

Source:
https://lore.kernel.org/linux-bcachefs/YYQZ+QmATIgKfzZ8@moria.home.lan/

What is the status of the above todo item regarding a distinct st_dev
value for each subvolume?

A second question:  On Btrfs, each subvolume has an inode value of 256.

Source:  https://btrfs.readthedocs.io/en/latest/Subvolumes.html

Is there any easy method for users (especially non-root users) to
identify Bcachefs subvolumes?

Thank you,

Parke
