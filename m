Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D30FFCDB465
	for <linux-bcachefs@archiver.kernel.org>; Thu, 19 Oct 2023 17:00:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233041AbjJSRAT (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 19 Oct 2023 13:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233147AbjJSRAS (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 19 Oct 2023 13:00:18 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BAC3130
        for <linux-bcachefs@vger.kernel.org>; Thu, 19 Oct 2023 10:00:13 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id 2adb3069b0e04-507a0907896so8156384e87.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 19 Oct 2023 10:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697734811; x=1698339611; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uIFWgO+sBLy9unfBjCxOzLy/zJCprivD05GJALtqNr8=;
        b=PRN7yMv0N/gHPAyWno5oqH/DMhmapQ5yNNTkXyftGRCQHcIEMMsXlzOmpYuwlt8pwo
         FccV+vmtIZuVnqaqIWRZiMnO6gMJhibSFHyEjuhKwFnH6VU7JC+7eQmoGZHloAJQS4FY
         UuBZoWgbpqgTCgWjx9sjs18mbAY37oTRYU0ma9erl80LkHJ29/FG9aLspsJBCU8sxmbg
         1RRw3jzldRDCVH02C/HSdbwVoNEARC7SB0QGzOLjH8DvRnBjk8X1PXWQane78ss7Hzwz
         CPigBkAUOGIWJ7EHQrjFutVKUuQgpd6r0hIgfxDDR3EI/DV/E8WtUTT4v88cqW5MYsM7
         GWbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697734811; x=1698339611;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uIFWgO+sBLy9unfBjCxOzLy/zJCprivD05GJALtqNr8=;
        b=h6h6qNwXUMgZXVSLketGjbz+sZavAS/kAY7/xEGmReeOJCzedS35MtEnuqXxI6PWsY
         bAmbbxbOPVAN39fkDJQUYikocO6VViF0iCgcCeFiVRA5l06I5Cn4NEgWljJ+yT0MM6jT
         PfAq6NeguETlBDw80lcbxe+qQtYufCA/dl7i4OLp/Y/w/P9AyxVjfsq2e4ZpGoq78Bv8
         +hnXHtANZfNxenAbOZ8EquCPh24OltdBwHWTSo/OWQa+UGaFeLrJ1pqNW+8o2sqG6jVQ
         2FMrHy3xE5H4sqf1ftBqdb3EetlKiBytHYt8eA1I5CtJPnSRhq29DxekHAULS3FJf20g
         w0lw==
X-Gm-Message-State: AOJu0YxqK3EXl9jfS8/yZhQvVjVc5WqE+jsqeWqZ8HqdwqkqcX9F8lOl
        P7us8/jJ5yIhWrHTYE/NpQGsh9N4KnsvoW0snJq7IDxs
X-Google-Smtp-Source: AGHT+IGLG5wfVvqNeB3SzmgnPL/XaT7Iy1HOe7USk2eboKWFIDUrzo84E8+GALbeLN2+LJUl68hgkO548nREg4JhgHs=
X-Received: by 2002:a19:5206:0:b0:502:9fce:b6d4 with SMTP id
 m6-20020a195206000000b005029fceb6d4mr1908107lfb.25.1697734811234; Thu, 19 Oct
 2023 10:00:11 -0700 (PDT)
MIME-Version: 1.0
References: <CAPxz1+Yt644v4q-ahjE46Sh_ZZSE2r=wwSaup4nYC4uYgQy+rA@mail.gmail.com>
 <20231018202955.i2xjqqpd7cubunvg@moria.home.lan> <CAPxz1+ZTODcUt=nbToDtpsHr1LW04VNVqDPJNV2QhuXb-=+CnQ@mail.gmail.com>
 <20231019002654.cgsmfhu6pxnh4vro@moria.home.lan> <CAPxz1+YcGd23wH4J+Vo1ES6-ncMaW0ga6DSxehS8Ty=t6rTbNg@mail.gmail.com>
 <20231019004704.ehjplvjlhzqgnyx6@moria.home.lan>
In-Reply-To: <20231019004704.ehjplvjlhzqgnyx6@moria.home.lan>
From:   Parke <parke.nexus@gmail.com>
Date:   Thu, 19 Oct 2023 09:59:35 -0700
Message-ID: <CAPxz1+ZsY9-v_Fw5_qMF_0S3rVZYn1oFUtVusFjOFP4JQY7CdQ@mail.gmail.com>
Subject: Re: Bcachefs: export a different st_dev for each subvolume
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Oct 18, 2023 at 5:47=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
> So, in that case, you just need a single bit reported via stat() or
> statx().
>
> Unfortunately, I don't see a flags field in struct statx...

After some more contemplation, I think I am going to implement
colorization of st_dev differences.  (As I originally envisioned, and
as Kent previously suggested.)

This means that if/when Bcachefs implements distinct st_dev's for each
subvolume, my modified version of ls will be able to display them in a
custom color.

Cheers,

Parke
