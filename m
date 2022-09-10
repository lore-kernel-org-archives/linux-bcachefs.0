Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DFB5C6FA82
	for <linux-bcachefs@archiver.kernel.org>; Sat, 10 Sep 2022 04:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiIJEUu (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 10 Sep 2022 00:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiIJEUt (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 10 Sep 2022 00:20:49 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE485E337
        for <linux-bcachefs@vger.kernel.org>; Fri,  9 Sep 2022 21:20:48 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id u18so6024216lfo.8
        for <linux-bcachefs@vger.kernel.org>; Fri, 09 Sep 2022 21:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=temp123.org; s=google;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=Z5y6Dr6EJHzT8UImK0vpeQ1l4gxKcVdDWiCA6w7yewM=;
        b=j28GTPMUU4ptyIwhO/hWjic7DtqO6+chYuWQB4N4bLlCwMUC6Ii3LOOhZAixSwXqS2
         +SeWtCrPle3oOn8uoUKOKtNi9utZJTtGMg7lvsHKt1IebhPgE3coszR8vOkDso7q9Te6
         TJBX2FUOFOrqYn8g64c7uqhHKxQAQyGvaXUXo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=Z5y6Dr6EJHzT8UImK0vpeQ1l4gxKcVdDWiCA6w7yewM=;
        b=t19LKLpzfvu6YMhsvcR88AmWcsusjYPpXiMw3YIzwM2QuPNW0GDdaez8tDCZYpCZoG
         Cb9kTp+dwRErYYkyeU/oL10usHa+R+9fSiVDk+aX1CiLtLtYEiqJX8e3RqAdwFVjZNDD
         68g9szrhfruAD7NJipiSwUXRgP1QkKSyBFZOokUtpRh9Bo8Wsqe9kQTh0YrTaE7u3Zn9
         lYYye4RI+wvmhpqUmx+3oi1o7pkgyuGufe9T0f0NlUPW+2IzWL0Fc5dvLaFg63Ec7jNN
         RCXq0sqgPUy0NMo+yUJdFXVZFB7u5GVRaTpyrMaMj7vThy3qXxddOVbl4aLqgQFzGt2S
         7oAA==
X-Gm-Message-State: ACgBeo2mfD3BBC59lwsKECY+IQ9KenCAHADGGcdGOADgEpSA9pCIjR04
        /J4s0bjW+HcHm0CGuYjflaNY2WlI01Ui+vQRTuxBnm8d2nF1kg==
X-Google-Smtp-Source: AA6agR6uQFuPVTmK8dUn+JGUKu9kJhIHxVsmFrGgMyRQV4RXbzL4wdqyWpf9acKc0uS6yZ5lZJriG5mofvG6dLht4Ls=
X-Received: by 2002:a05:6512:3c8d:b0:48a:f74a:67b6 with SMTP id
 h13-20020a0565123c8d00b0048af74a67b6mr6238119lfv.231.1662783646625; Fri, 09
 Sep 2022 21:20:46 -0700 (PDT)
MIME-Version: 1.0
From:   Josh Litherland <josh@temp123.org>
Date:   Sat, 10 Sep 2022 00:20:35 -0400
Message-ID: <CAKib_wJJCYxOzNqCAQOBBn2Y5mNgVXk-0Oow9Y0_=JNJvbgeDg@mail.gmail.com>
Subject: Secondary Superblock?
To:     linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Is there a secondary superblock somewhere on a bcachefs volume that I
can recover from in the event the primary gets overwritten?

Context: I have/had an encrypted bcachefs laid across 4 hard drives
and 2 ssds.  Prior to experimenting with bcachefs, I had LUKS
encryption on the same drives.  I accidentally ran an old script that
ran "cryptsetup open" on all the drives, which astonishingly (1)
worked at all, and (2) overwrote the bcachefs superblock with a LUKS
one.  I'm still investigating how the hell that happened, but I have
reproduced it in testing.

Is there any chance of finding a working copy of my bcachefs
superblock and restoring it?

-- 
Josh Litherland (josh@temp123.org)
