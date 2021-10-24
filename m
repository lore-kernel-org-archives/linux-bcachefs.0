Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47B4DC4332F
	for <linux-bcachefs@archiver.kernel.org>; Sun, 24 Oct 2021 15:40:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30A4B60EBC
	for <linux-bcachefs@archiver.kernel.org>; Sun, 24 Oct 2021 15:40:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbhJXPmv (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 24 Oct 2021 11:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232131AbhJXPmo (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 24 Oct 2021 11:42:44 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4772DC061745
        for <linux-bcachefs@vger.kernel.org>; Sun, 24 Oct 2021 08:40:23 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id x123so9572792qke.7
        for <linux-bcachefs@vger.kernel.org>; Sun, 24 Oct 2021 08:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=U6LBtkVCB9XZgOuUoVBE+PbcIi+XSAorOA6Yq7uerwk=;
        b=L5ion0L6/H4edjsVdtwNQpJt0oqJIa9dyqMgmNlW3g5VT3lNvJYoMl/vkJdWcj2UiG
         FCaTTTagnuuvk1obbGHfL5C0JQd/ZY3SfV52FO3wAmR4OB0qa5Tkw0vvw44Ed+sEGNhM
         yKS+rJaxxT+jfASdxdy+TU6Ce0e3mRXrRKBf+cm552XGLxAca6OqtDTmSMe/HjIC4pso
         xml5IQ8vJ1eLEllDSDic9BgvAdlxlCKU8zWPHD+qn/w25viEHDBbPpJ9u1KYncWD2e4Y
         kDG2CqTpA8SJzVkIR2BvrDxpAOaJ57HBDBZT34AMjxjMtHvZnOq+xC5QnwYIpPd6PsO9
         ui4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U6LBtkVCB9XZgOuUoVBE+PbcIi+XSAorOA6Yq7uerwk=;
        b=XLcDbLsSHhKYBe1TYaXPhQXVnLgeQrTsj40XYy1ZMS6TzjWygHhunddPSggFuoS9jR
         ZaaWVa6sIZIsTMtO0/QDOtZfMwRV5j2C1EA21I5nMYGTj+sP9RZo9fQ5wWYe+I1OOvMr
         JXb6/MKRDvONIWdsB2Peb5yQnM+su1hBePMq8bjaR+GWE/AW7fxuAmOpO5h6rV4Tt+a+
         9Wqi6vQTqIJxgwe5cJoGNOGbiYfny8eGboaLGGtJVDeqv2WkO/1j9uAx8U6tfidR7d3e
         PNGwSyb11OywunzN64/1QWhcaWCbacAmcLK2tdZrU+60ZBY70Y6duJGEVBoBjnRTBsuJ
         04Qg==
X-Gm-Message-State: AOAM533BKuEh+womZIh8cU5MkEAV1KNssmuHfiE5YnbbrzdH244QBjFz
        ItT3V+TvYJ1nsRW7yD5Wf55u4r6EeWdG
X-Google-Smtp-Source: ABdhPJzh392C0bZIzz3AE9vnkGRrpIeBwNW3IyKi2TBY+lKoDLVvGlmKdjP3G7UsGNbaQJo2rS4ouQ==
X-Received: by 2002:a37:a444:: with SMTP id n65mr9656967qke.408.1635090022311;
        Sun, 24 Oct 2021 08:40:22 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id u185sm7404813qkd.48.2021.10.24.08.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Oct 2021 08:40:21 -0700 (PDT)
Date:   Sun, 24 Oct 2021 11:40:09 -0400
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Chris Webb <chris@arachsys.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] [bcachefs-tools] Cosmetic fixes for device resize-journal
Message-ID: <YXV+WX6Vk9HRJexH@moria.home.lan>
References: <20211024125232.GH11670@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211024125232.GH11670@arachsys.com>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sun, Oct 24, 2021 at 01:52:32PM +0100, Chris Webb wrote:
> Correct the operation name from 'journal-resize' to 'resize-journal' in the
> bcachefs usage summary, matching the command that is actually implemented.
> 
> Fix the size argument so it isn't optional. Defaulting to the entire device
> makes sense for 'device resize', to automatically expand the fs to fill the
> block device. However, it is never meaningful (or possible) to expand the
> journal to the full disk.

Applied, thanks!
