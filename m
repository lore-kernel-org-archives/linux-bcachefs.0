Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A9B3C433F5
	for <linux-bcachefs@archiver.kernel.org>; Mon, 11 Oct 2021 19:20:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43B3C60F43
	for <linux-bcachefs@archiver.kernel.org>; Mon, 11 Oct 2021 19:20:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbhJKTWy (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 11 Oct 2021 15:22:54 -0400
Received: from cdw.me.uk ([91.203.57.136]:48649 "EHLO cdw.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233372AbhJKTWx (ORCPT <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 11 Oct 2021 15:22:53 -0400
Received: from chris by delta.arachsys.com with local (Exim 4.80)
        (envelope-from <chris@arachsys.com>)
        id 1ma0qy-000820-GM; Mon, 11 Oct 2021 20:20:52 +0100
Date:   Mon, 11 Oct 2021 20:20:52 +0100
From:   Chris Webb <chris@arachsys.com>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: rmdir() succeeds on an empty subvolume
Message-ID: <20211011192052.GB20049@arachsys.com>
References: <20211010134413.GA31142@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211010134413.GA31142@arachsys.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Chris Webb <chris@arachsys.com> writes:

> If I create an empty snapshot in a bcachefs filesystem, I can then remove
> the snapshot directory causing the filesystem to drop into an emergency
> read-only state:

Following up for completeness: this one is fixed by 33a19429e827 which you
pushed earlier today. Thanks!

Best wishes,

Chris.
