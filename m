Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41C31C4332F
	for <linux-bcachefs@archiver.kernel.org>; Mon, 30 Oct 2023 20:26:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbjJ3U0J (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 30 Oct 2023 16:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjJ3U0I (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 30 Oct 2023 16:26:08 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DDBFFF
        for <linux-bcachefs@vger.kernel.org>; Mon, 30 Oct 2023 13:26:05 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D53C433C8;
        Mon, 30 Oct 2023 20:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1698697564;
        bh=xwYBWcdFaQ23mQm4ZiISdzH+b1RKq5bK95AoxqMh8M4=;
        h=Date:From:To:Subject:From;
        b=jVJD4ltYlzaSc6CtsU/7IOXrS39PCD+WZTAWnB5tsY4RWY/iD+AoLlgzdrkF1ddTA
         Nw2yjc0z7wrvhw5LJr0bug31Gu2LMdSd0gkPFimUiTkhCEvxQYiqMxhTZqMT8+jiCw
         Zug/an/7S8DdEpwq+vJfIhN4C2HqaQ82sj7WOXKs=
Date:   Mon, 30 Oct 2023 16:26:03 -0400
From:   Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To:     linux-bcachefs@vger.kernel.org
Subject: PSA: migrating linux-bcachefs to new vger infrastructure
Message-ID: <20231030-manul-of-awesome-masquerade-f3ecec@nitro>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Good day!

I plan to migrate the linux-bcachefs@vger.kernel.org list to the new
infrastructure this week. We're still doing it list-by-list to make sure that
we don't run into scaling issues with the new infra.

The migration will be performed live and should require any downtime.

Please speak up if you have any objections.

Best wishes,
-K
